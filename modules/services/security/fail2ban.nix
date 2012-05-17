{ config, pkgs, ... }:

with pkgs.lib;

let

  fail2banConf = pkgs.writeText "fail2ban.conf"
    ''
      [Definition]
      loglevel  = 3
      logtarget = SYSLOG
      socket    = /var/run/fail2ban/fail2ban.sock
    '';

  jailConf = pkgs.writeText "jail.conf"
    ''
      [DEFAULT]
      bantime  = 120
      findtime = 120
      maxretry = 3
      backend  = auto
    
      [ssh-iptables]
      enabled  = true
      filter   = sshd
      action   = iptables[name=SSH, port=ssh, protocol=tcp]
      logpath  = /var/log/warn
      maxretry = 5
    '';

in
    
{

  ###### interface

  options = {

  };

  
  ###### implementation

  config = {

    environment.systemPackages = [ pkgs.fail2ban ];

    environment.etc =
      [ { source = fail2banConf;
          target = "fail2ban/fail2ban.conf";
        }
        { source = jailConf;
          target = "fail2ban/jail.conf";
        }
        { source = "${pkgs.fail2ban}/etc/fail2ban/action.d";
          target = "fail2ban/action.d";
        }
        { source = "${pkgs.fail2ban}/etc/fail2ban/filter.d";
          target = "fail2ban/filter.d";
        }
      ];

    jobs.fail2ban =
      { description = "Fail2ban intrusion prevention system";
      
        startOn = "started networking";
        
        path = [ pkgs.fail2ban pkgs.iptables ];
        
        preStart =
          ''
            # ${fail2banConf} ${jailConf}
            mkdir -p /var/run/fail2ban -m 0755
          '';
          
        exec = "fail2ban-server -f";

        postStart =
          ''
            fail2ban-client reload
          '';
        
        respawn = false;
      };
  
  };

}
