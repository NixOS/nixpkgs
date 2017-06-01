{ config, lib, pkgs, ... }:

with lib;

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
      ${lib.concatStrings (map (job: job + "\n") config.services.cron.systemCronJobs)}
    '';

  allowdeny = target: users:
    { source = pkgs.writeText "fcron.${target}" (concatStringsSep "\n" users);
      target = "fcron.${target}";
      mode = "644";
      gid = config.ids.gids.fcron;
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
        { source = pkgs.writeText "fcron.conf" ''
            fcrontabs   =       /var/spool/fcron
            pidfile     =       /var/run/fcron.pid
            fifofile    =       /var/run/fcron.fifo
            fcronallow  =       /etc/fcron.allow
            fcrondeny   =       /etc/fcron.deny
            shell       =       /bin/sh
            sendmail    =       /run/wrappers/bin/sendmail
            editor      =       ${pkgs.vim}/bin/vim
          '';
          target = "fcron.conf";
          gid = config.ids.gids.fcron;
          mode = "0644";
        }
      ];

    environment.systemPackages = [ pkgs.fcron ];
    users.extraUsers.fcron = {
      uid = config.ids.uids.fcron;
      home = "/var/spool/fcron";
      group = "fcron";
    };
    users.groups.fcron.gid = config.ids.gids.fcron;

    security.wrappers = {
      fcrontab = {
        source = "${pkgs.fcron}/bin/fcrontab";
        owner = "fcron";
        group = "fcron";
        setgid = true;
      };
      fcrondyn = {
        source = "${pkgs.fcron}/bin/fcrondyn";
        owner = "fcron";
        group = "fcron";
        setgid = true;
      };
      fcronsighup = {
        source = "${pkgs.fcron}/bin/fcronsighup";
        group = "fcron";
      };
    };
    systemd.services.fcron = {
      description = "fcron daemon";
      after = [ "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];

      # FIXME use specific path
      environment = {
        PATH = "/run/current-system/sw/bin";
      };

      preStart = ''
        install \
          --mode 0770 \
          --owner fcron \
          --group fcron \
          --directory /var/spool/fcron
        # load system crontab file
        /run/wrappers/bin/fcrontab -u systab ${pkgs.writeText "systab" cfg.systab}
      '';

      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.fcron}/sbin/fcron -m ${toString cfg.maxSerialJobs} ${queuelen}";
      };
    };
  };
}
