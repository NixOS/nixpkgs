{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.fail2ban;

  fail2banConf = pkgs.writeText "fail2ban.conf" cfg.daemonConfig;

  jailConf = pkgs.writeText "jail.conf"
    (concatStringsSep "\n" (attrValues (flip mapAttrs cfg.jails (name: def:
      optionalString (def != "") 
        ''
          [${name}]
          ${def}
        ''))));

in

{

  ###### interface

  options = {

    services.fail2ban = {

      daemonConfig = mkOption {
        default =
          ''
            [Definition]
            loglevel  = 3
            logtarget = SYSLOG
            socket    = /var/run/fail2ban/fail2ban.sock
          '';
        type = types.string;
        description =
          ''
            The contents of Fail2ban's main configuration file.  It's
            generally not necessary to change it.
          '';
      };

      jails = mkOption {
        default = { };
        example =
          { "apache-nohome-iptables" =
              ''
                # Block an IP address if it accesses a non-existent
                # home directory more than 5 times in 10 minutes,
                # since that indicates that it's scanning.
                filter   = apache-nohome
                action   = iptables-multiport[name=HTTP, port="http,https"]
                logpath  = /var/log/httpd/error_log*
                findtime = 600
                bantime  = 600
                maxretry = 5
              '';
          };
        type = types.attrsOf types.string;
        description =
          ''
            The configuration of each Fail2ban “jail”.  A jail
            consists of an action (such as blocking a port using
            <command>iptables</command>) that is triggered when a
            filter applied to a log file triggers more than a certain
            number of times in a certain time period.  Actions are
            defined in <filename>/etc/fail2ban/action.d</filename>,
            while filters are defined in
            <filename>/etc/fail2ban/filter.d</filename>.
          '';
      };
      
    };

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
            # FIXME: this won't detect changes to
            # /etc/fail2ban/{filter.d,action.d}.
            # ${fail2banConf} ${jailConf}
            mkdir -p /var/run/fail2ban -m 0755
          '';
          
        exec = "fail2ban-server -f";

        postStart =
          ''
            fail2ban-client reload
          '';
      };

    # Add some reasonable default jails.  The special "DEFAULT" jail
    # sets default values for all other jails.
    services.fail2ban.jails.DEFAULT =
      ''
        ignoreip = 127.0.0.1/8
        bantime  = 600
        findtime = 600
        maxretry = 3
        backend  = auto
      '';

    # Block SSH if there are too many failing connection attempts.
    services.fail2ban.jails."ssh-iptables" =
      ''
        filter   = sshd
        action   = iptables[name=SSH, port=ssh, protocol=tcp]
        logpath  = /var/log/warn
        maxretry = 5
      '';
    
  };

}
