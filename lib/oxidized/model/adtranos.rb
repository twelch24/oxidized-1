class AdtranOS < Oxidized::Model

  # Adtran Operating System (AOS) 

  prompt /^[\w .-]+(:|>|#)$/
  comment  '!'

  cmd 'show running-config' do |cfg|
    cfg.gsub! /! Created[ ]+:.*/, '\\1 <removed>'
    cfg
  end

  cfg :telnet do
    username /^Username:/
    password /^Password:/
  end

  cfg :ssh do
    username /^login as: /
    password /^[\w .-@']+password(:|>|#) $/
  end

  cfg :telnet, :ssh do
    post_login 'terminal length 0'
    if vars :enable
      post_login do
        send "enable\n"
        cmd vars(:enable)
      end
    end
    pre_logout do
      send "exit\n"
      send "\n\n"
    end
  end

end
