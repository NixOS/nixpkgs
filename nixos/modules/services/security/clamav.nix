{ config, lib, pkgs, ... }:
with lib;
let
  clamavUser = "clamav";
  stateDir = "/var/lib/clamav";
  runDir = "/run/clamav";
  clamavGroup = clamavUser;
  cfg = config.services.clamav;
  pkg = pkgs.clamav;

  clamdConfigFile = pkgs.writeText "clamd.conf" ''
    DatabaseDirectory ${stateDir}
    LocalSocket ${runDir}/clamd.ctl
    PidFile ${runDir}/clamd.pid
    TemporaryDirectory /tmp
    User clamav
    Foreground yes

    ${cfg.daemon.extraConfig}
  '';

  freshclamConfigFile = pkgs.writeText "freshclam.conf" ''
    DatabaseDirectory ${stateDir}
    Foreground yes
    Checks ${toString cfg.updater.frequency}

    ${cfg.updater.extraConfig}

    DatabaseMirror database.clamav.net
  '';
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "clamav" "updater" "config" ] [ "services" "clamav" "updater" "extraConfig" ])
  ];

  options = {
    services.clamav = {
      daemon = {
        enable = mkEnableOption "ClamAV clamd daemon";

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Extra configuration for clamd. Contents will be added verbatim to the
            configuration file.
          '';
        };
      };
      updater = {
        enable = mkEnableOption "ClamAV freshclam updater";

        frequency = mkOption {
          type = types.int;
          default = 12;
          description = ''
            Number of database checks per day.
          '';
        };

        interval = mkOption {
          type = types.str;
          default = "hourly";
          description = ''
            How often freshclam is invoked. See systemd.time(7) for more
            information about the format.
          '';
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Extra configuration for freshclam. Contents will be added verbatim to the
            configuration file.
          '';
        };
      };
    };
  };

  config = mkIf (cfg.updater.enable || cfg.daemon.enable) {
    environment.systemPackages = [ pkg ];

    users.users.${clamavUser} = {
      uid = config.ids.uids.clamav;
      group = clamavGroup;
      description = "ClamAV daemon user";
      home = stateDir;
    };

    users.groups.${clamavGroup} =
      { gid = config.ids.gids.clamav; };

    environment.etc."clamav/freshclam.conf".source = freshclamConfigFile;
    environment.etc."clamav/clamd.conf".source = clamdConfigFile;

    systemd.services.clamav-daemon = mkIf cfg.daemon.enable {
      description = "ClamAV daemon (clamd)";
      after = optional cfg.updater.enable "clamav-freshclam.service";
      requires = optional cfg.updater.enable "clamav-freshclam.service";
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ clamdConfigFile ];

      preStart = ''
        mkdir -m 0755 -p ${runDir}
        chown ${clamavUser}:${clamavGroup} ${runDir}
      '';

      serviceConfig = {
        ExecStart = "${pkg}/bin/clamd";
        ExecReload = "${pkgs.coreutils}/bin/kill -USR2 $MAINPID";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        PrivateNetwork = "yes";
      };
    };

    systemd.timers.clamav-freshclam = mkIf cfg.updater.enable {
      description = "Timer for ClamAV virus database updater (freshclam)";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.updater.interval;
        Unit = "clamav-freshclam.service";
      };
    };

    systemd.services.clamav-freshclam = mkIf cfg.updater.enable {
      description = "ClamAV virus database updater (freshclam)";
      restartTriggers = [ freshclamConfigFile ];

      preStart = ''
        mkdir -m 0755 -p ${stateDir}
        chown ${clamavUser}:${clamavGroup} ${stateDir}
      '';

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkg}/bin/freshclam";
        SuccessExitStatus = "1"; # if databases are up to date
        PrivateTmp = "yes";
        PrivateDevices = "yes";
      };
    };
  };
}
