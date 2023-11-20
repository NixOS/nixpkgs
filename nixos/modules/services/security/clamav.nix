{ config, lib, pkgs, ... }:
with lib;
let
  clamavUser = "clamav";
  stateDir = "/var/lib/clamav";
  runDir = "/run/clamav";
  clamavGroup = clamavUser;
  cfg = config.services.clamav;
  pkg = pkgs.clamav;

  toKeyValue = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault { } " ";
    listsAsDuplicateKeys = true;
  };

  clamdConfigFile = pkgs.writeText "clamd.conf" (toKeyValue cfg.daemon.settings);
  freshclamConfigFile = pkgs.writeText "freshclam.conf" (toKeyValue cfg.updater.settings);
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "clamav" "updater" "config" ] "Use services.clamav.updater.settings instead.")
    (mkRemovedOptionModule [ "services" "clamav" "updater" "extraConfig" ] "Use services.clamav.updater.settings instead.")
    (mkRemovedOptionModule [ "services" "clamav" "daemon" "extraConfig" ] "Use services.clamav.daemon.settings instead.")
  ];

  options = {
    services.clamav = {
      daemon = {
        enable = mkEnableOption (lib.mdDoc "ClamAV clamd daemon");

        settings = mkOption {
          type = with types; attrsOf (oneOf [ bool int str (listOf str) ]);
          default = { };
          description = lib.mdDoc ''
            ClamAV configuration. Refer to <https://linux.die.net/man/5/clamd.conf>,
            for details on supported values.
          '';
        };
      };
      updater = {
        enable = mkEnableOption (lib.mdDoc "ClamAV freshclam updater");

        frequency = mkOption {
          type = types.int;
          default = 12;
          description = lib.mdDoc ''
            Number of database checks per day.
          '';
        };

        interval = mkOption {
          type = types.str;
          default = "hourly";
          description = lib.mdDoc ''
            How often freshclam is invoked. See systemd.time(7) for more
            information about the format.
          '';
        };

        settings = mkOption {
          type = with types; attrsOf (oneOf [ bool int str (listOf str) ]);
          default = { };
          description = lib.mdDoc ''
            freshclam configuration. Refer to <https://linux.die.net/man/5/freshclam.conf>,
            for details on supported values.
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

    services.clamav.daemon.settings = {
      DatabaseDirectory = stateDir;
      LocalSocket = "${runDir}/clamd.ctl";
      PidFile = "${runDir}/clamd.pid";
      TemporaryDirectory = "/tmp";
      User = "clamav";
      Foreground = true;
    };

    services.clamav.updater.settings = {
      DatabaseDirectory = stateDir;
      Foreground = true;
      Checks = cfg.updater.frequency;
      DatabaseMirror = [ "database.clamav.net" ];
    };

    environment.etc."clamav/freshclam.conf".source = freshclamConfigFile;
    environment.etc."clamav/clamd.conf".source = clamdConfigFile;

    systemd.services.clamav-daemon = mkIf cfg.daemon.enable {
      description = "ClamAV daemon (clamd)";
      after = optional cfg.updater.enable "clamav-freshclam.service";
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ clamdConfigFile ];

      serviceConfig = {
        ExecStart = "${pkg}/bin/clamd";
        ExecReload = "${pkgs.coreutils}/bin/kill -USR2 $MAINPID";
        User = clamavUser;
        Group = clamavGroup;
        StateDirectory = "clamav";
        RuntimeDirectory = "clamav";
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
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkg}/bin/freshclam";
        SuccessExitStatus = "1"; # if databases are up to date
        StateDirectory = "clamav";
        RuntimeDirectory = "clamav";
        User = clamavUser;
        Group = clamavGroup;
        PrivateTmp = "yes";
        PrivateDevices = "yes";
      };
    };
  };
}
