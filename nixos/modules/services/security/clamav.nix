{ config, lib, pkgs, ... }:
with lib;
let
  clamavUser = "clamav";
  stateDir = "/var/lib/clamav";
  clamavGroup = clamavUser;
  cfg = config.services.clamav;
  pkg = pkgs.clamav;

  toKeyValue = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault { } " ";
    listsAsDuplicateKeys = true;
  };

  clamdConfigFile = pkgs.writeText "clamd.conf" (toKeyValue cfg.daemon.settings);
  freshclamConfigFile = pkgs.writeText "freshclam.conf" (toKeyValue cfg.updater.settings);
  fangfrischConfigFile = pkgs.writeText "fangfrisch.conf" ''
    ${lib.generators.toINI {} cfg.fangfrisch.settings}
  '';
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
        enable = mkEnableOption "ClamAV clamd daemon";

        settings = mkOption {
          type = with types; attrsOf (oneOf [ bool int str (listOf str) ]);
          default = { };
          description = ''
            ClamAV configuration. Refer to <https://linux.die.net/man/5/clamd.conf>,
            for details on supported values.
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

        settings = mkOption {
          type = with types; attrsOf (oneOf [ bool int str (listOf str) ]);
          default = { };
          description = ''
            freshclam configuration. Refer to <https://linux.die.net/man/5/freshclam.conf>,
            for details on supported values.
          '';
        };
      };
      fangfrisch = {
        enable = mkEnableOption "ClamAV fangfrisch updater";

        interval = mkOption {
          type = types.str;
          default = "hourly";
          description = ''
            How often freshclam is invoked. See systemd.time(7) for more
            information about the format.
          '';
        };

        settings = mkOption {
          type = lib.types.submodule {
            freeformType = with types; attrsOf (attrsOf (oneOf [ str int bool ]));
          };
          default = { };
          example = {
            securiteinfo = {
              enabled = "yes";
              customer_id = "your customer_id";
            };
          };
          description = ''
            fangfrisch configuration. Refer to <https://rseichter.github.io/fangfrisch/#_configuration>,
            for details on supported values.
            Note that by default urlhaus and sanesecurity are enabled.
          '';
        };
      };

      scanner = {
        enable = mkEnableOption "ClamAV scanner";

        interval = mkOption {
          type = types.str;
          default = "*-*-* 04:00:00";
          description = ''
            How often clamdscan is invoked. See systemd.time(7) for more
            information about the format.
            By default this runs using 10 cores at most, be sure to run it at a time of low traffic.
          '';
        };

        scanDirectories = mkOption {
          type = with types; listOf str;
          default = [ "/home" "/var/lib" "/tmp" "/etc" "/var/tmp" ];
          description = ''
            List of directories to scan.
            The default includes everything I could think of that is valid for nixos. Feel free to contribute a PR to add to the default if you see something missing.
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
      LocalSocket = "/run/clamav/clamd.ctl";
      PidFile = "/run/clamav/clamd.pid";
      User = "clamav";
      Foreground = true;
    };

    services.clamav.updater.settings = {
      DatabaseDirectory = stateDir;
      Foreground = true;
      Checks = cfg.updater.frequency;
      DatabaseMirror = [ "database.clamav.net" ];
    };

    services.clamav.fangfrisch.settings = {
      DEFAULT.db_url = mkDefault "sqlite:////var/lib/clamav/fangfrisch_db.sqlite";
      DEFAULT.local_directory = mkDefault stateDir;
      DEFAULT.log_level = mkDefault "INFO";
      urlhaus.enabled = mkDefault "yes";
      urlhaus.max_size = mkDefault "2MB";
      sanesecurity.enabled = mkDefault "yes";
    };

    environment.etc."clamav/freshclam.conf".source = freshclamConfigFile;
    environment.etc."clamav/clamd.conf".source = clamdConfigFile;

    systemd.services.clamav-daemon = mkIf cfg.daemon.enable {
      description = "ClamAV daemon (clamd)";
      after = optionals cfg.updater.enable [ "clamav-freshclam.service" ];
      wants = optionals cfg.updater.enable [ "clamav-freshclam.service" ];
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
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkg}/bin/freshclam";
        SuccessExitStatus = "1"; # if databases are up to date
        StateDirectory = "clamav";
        User = clamavUser;
        Group = clamavGroup;
        PrivateTmp = "yes";
        PrivateDevices = "yes";
      };
    };

    systemd.services.clamav-fangfrisch-init = mkIf cfg.fangfrisch.enable {
      wantedBy = [ "multi-user.target" ];
      # if the sqlite file can be found assume the database has already been initialised
      script = ''
        db_url="${cfg.fangfrisch.settings.DEFAULT.db_url}"
        db_path="''${db_url#sqlite:///}"

        if [ ! -f "$db_path" ]; then
          ${pkgs.fangfrisch}/bin/fangfrisch --conf ${fangfrischConfigFile} initdb
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        StateDirectory = "clamav";
        User = clamavUser;
        Group = clamavGroup;
        PrivateTmp = "yes";
        PrivateDevices = "yes";
      };
    };

    systemd.timers.clamav-fangfrisch = mkIf cfg.fangfrisch.enable {
      description = "Timer for ClamAV virus database updater (fangfrisch)";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.fangfrisch.interval;
        Unit = "clamav-fangfrisch.service";
      };
    };

    systemd.services.clamav-fangfrisch = mkIf cfg.fangfrisch.enable {
      description = "ClamAV virus database updater (fangfrisch)";
      restartTriggers = [ fangfrischConfigFile ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" "clamav-fangfrisch-init.service" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.fangfrisch}/bin/fangfrisch --conf ${fangfrischConfigFile} refresh";
        StateDirectory = "clamav";
        User = clamavUser;
        Group = clamavGroup;
        PrivateTmp = "yes";
        PrivateDevices = "yes";
      };
    };

    systemd.timers.clamdscan = mkIf cfg.scanner.enable {
      description = "Timer for ClamAV virus scanner";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.scanner.interval;
        Unit = "clamdscan.service";
      };
    };

    systemd.services.clamdscan = mkIf cfg.scanner.enable {
      description = "ClamAV virus scanner";
      after = optionals cfg.updater.enable [ "clamav-freshclam.service" ];
      wants = optionals cfg.updater.enable [ "clamav-freshclam.service" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkg}/bin/clamdscan --multiscan --fdpass --infected --allmatch ${lib.concatStringsSep " " cfg.scanner.scanDirectories}";
      };
    };
  };
}
