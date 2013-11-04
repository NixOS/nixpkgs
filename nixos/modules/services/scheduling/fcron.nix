{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.fcron;

  queuelen = if cfg.queuelen == null then "" else "-q ${toString cfg.queuelen}";

  # Duplicate code, also found in cron.nix. Needs deduplication.
  systemCronJobs =
    ''
      SHELL=${pkgs.bash}/bin/bash
      PATH=${config.system.path}/bin:${config.system.path}/sbin
      ${optionalString (config.services.cron.mailto != null) ''
        MAILTO="${config.services.cron.mailto}"
      ''}
      NIX_CONF_DIR=/etc/nix
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
        type = types.bool;
        default = false;
        description = "Whether to enable the <command>fcron</command> daemon.";
      };

      allow = mkOption {
        type = types.listOf types.str;
        default = [ "all" ];
        description = ''
          Users allowed to use fcrontab and fcrondyn (one name per
          line, <literal>all</literal> for everyone).
        '';
      };

      deny = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Users forbidden from using fcron.";
      };

      maxSerialJobs = mkOption {
        type = types.int;
        default = 1;
        description = "Maximum number of serial jobs which can run simultaneously.";
      };

      queuelen = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Number of jobs the serial queue and the lavg queue can contain.";
      };

      systab = mkOption {
        type = types.lines;
        default = "";
        description = ''The "system" crontab contents.'';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.fcron.systab = systemCronJobs;

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
            editor      =       /run/current-system/sw/bin/vi
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

        after = [ "local-fs.target" ];

        environment =
          { PATH = "/run/current-system/sw/bin";
          };

        preStart =
          ''
            ${pkgs.coreutils}/bin/mkdir -m 0700 -p /var/spool/fcron
            # load system crontab file
            ${pkgs.fcron}/bin/fcrontab -u systab ${pkgs.writeText "systab" cfg.systab}
          '';

        daemonType = "fork";

        exec = "${pkgs.fcron}/sbin/fcron -m ${toString cfg.maxSerialJobs} ${queuelen}";
      };

  };

}
