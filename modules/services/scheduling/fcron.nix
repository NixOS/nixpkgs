{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.fcron;
  
  queuelen = if cfg.queuelen == "" then "" else "-q ${toString cfg.queuelen}";

  systemCronJobsFile = pkgs.writeText "system-crontab"
    ''
      SHELL=${pkgs.bash}/bin/bash
      PATH=${config.system.path}/bin:${config.system.path}/sbin
      MAILTO="${config.services.cron.mailto}"
      NIX_CONF_DIR=/nix/etc/nix
      ${pkgs.lib.concatStrings (map (job: job + "\n") config.services.cron.systemCronJobs)}
    '';

  allowdeny = target: users:
    { source = pkgs.writeText "fcron.${target}" (concatStringsSep "\n" users);
      target = "fcron.${target}";
      mode = "600"; # fcron has some security issues.. So I guess this is most safe
    };

in

{

  ###### interface
  
  options = {
  
    services.fcron = {
    
      enable = mkOption {
        default = false;
        description = "Whether to enable the `fcron' daemon.";
      };
      
      allow = mkOption {
        default = [ "all" ];
        description = ''
          Users allowed to use fcrontab and fcrondyn (one name per line, "all" for everyone).
        '';
      };
      
      deny = mkOption {
        default = [];
        description = "Users forbidden from using fcron.";
      };
      
      maxSerialJobs = mkOption {
        default = 1;
        description = "Maximum number of serial jobs which can run simultaneously.";
      };
      
      queuelen = mkOption {
        default = "";
        description = "Number of jobs the serial queue and the lavg queue can contain - empty to net set this number (-q)";
      };
      
      systab = mkOption {
        default = systemCronJobsFile;
        description = ''The "system" crontab contents.'';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.etc =
      [ (allowdeny "allow" (cfg.allow))
        (allowdeny "deny" cfg.deny)
        # see man 5 fcron.conf
        { source = pkgs.writeText "fcon.conf" ''
            fcrontabs   =       /var/spool/fcron
            pidfile     =       /var/run/fcron.pid
            fifofile    =       /var/run/fcron.fifo
            fcronallow  =       /etc/fcron.allow
            fcrondeny   =       /etc/fcron.deny
            shell       =       /bin/sh
            sendmail    =       /var/setuid-wrappers/sendmail
            editor      =       /var/run/current-system/sw/bin/vi
          '';
          target = "fcron.conf";
          mode = "0600"; # max allowed is 644
        }
      ];

    environment.systemPackages = [ pkgs.fcron ];

    security.setuidPrograms = [ "fcrontab" ];

    jobs.fcron =
      { description = "fcron daemon";

        startOn = "startup";

        environment =
          { PATH = "/var/run/current-system/sw/bin";
          };

        preStart =
          ''
            ${pkgs.coreutils}/bin/mkdir -m 0700 -p /var/spool/fcron
            # load system crontab file
            ${pkgs.fcron}/bin/fcrontab -u systab ${pkgs.writeText "systab" cfg.systab}
          '';

        exec = "${pkgs.fcron}/sbin/fcron -f -m ${toString cfg.maxSerialJobs} ${queuelen}";
      };

  };

}
