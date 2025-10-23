{
  config,
  lib,
  pkgs,
  ...
}:
let
  clamavUser = "clamav";
  stateDir = "/var/lib/clamav";
  clamavGroup = clamavUser;
  cfg = config.services.clamav;

  toKeyValue = lib.generators.toKeyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault { } " ";
    listsAsDuplicateKeys = true;
  };

  clamdConfigFile = pkgs.writeText "clamd.conf" (toKeyValue cfg.daemon.settings);
  freshclamConfigFile = pkgs.writeText "freshclam.conf" (toKeyValue cfg.updater.settings);
  fangfrischConfigFile = pkgs.writeText "fangfrisch.conf" ''
    ${lib.generators.toINI { } cfg.fangfrisch.settings}
  '';
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "clamav"
      "updater"
      "config"
    ] "Use services.clamav.updater.settings instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "clamav"
      "updater"
      "extraConfig"
    ] "Use services.clamav.updater.settings instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "clamav"
      "daemon"
      "extraConfig"
    ] "Use services.clamav.daemon.settings instead.")
  ];

  options = {
    services.clamav = {
      package = lib.mkPackageOption pkgs "clamav" { };
      daemon = {
        enable = lib.mkEnableOption "ClamAV clamd daemon";

        settings = lib.mkOption {
          type =
            with lib.types;
            attrsOf (oneOf [
              bool
              int
              str
              (listOf str)
            ]);
          default = { };
          description = ''
            ClamAV configuration. Refer to <https://linux.die.net/man/5/clamd.conf>,
            for details on supported values.
          '';
        };
      };
      updater = {
        enable = lib.mkEnableOption "ClamAV freshclam updater";

        frequency = lib.mkOption {
          type = lib.types.int;
          default = 12;
          description = ''
            Number of database checks per day.
          '';
        };

        interval = lib.mkOption {
          type = lib.types.str;
          default = "hourly";
          description = ''
            How often freshclam is invoked. See {manpage}`systemd.time(7)` for more
            information about the format.
          '';
        };

        settings = lib.mkOption {
          type =
            with lib.types;
            attrsOf (oneOf [
              bool
              int
              str
              (listOf str)
            ]);
          default = { };
          description = ''
            freshclam configuration. Refer to <https://linux.die.net/man/5/freshclam.conf>,
            for details on supported values.
          '';
        };
      };
      fangfrisch = {
        enable = lib.mkEnableOption "ClamAV fangfrisch updater";

        interval = lib.mkOption {
          type = lib.types.str;
          default = "hourly";
          description = ''
            How often freshclam is invoked. See {manpage}`systemd.time(7)` for more
            information about the format.
          '';
        };

        settings = lib.mkOption {
          type = lib.types.submodule {
            freeformType =
              with lib.types;
              attrsOf (
                attrsOf (oneOf [
                  str
                  int
                  bool
                ])
              );
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
        enable = lib.mkEnableOption "ClamAV scanner";

        interval = lib.mkOption {
          type = lib.types.str;
          default = "*-*-* 04:00:00";
          description = ''
            How often clamdscan is invoked. See {manpage}`systemd.time(7)` for more
            information about the format.
            By default this runs using 10 cores at most, be sure to run it at a time of low traffic.
          '';
        };

        scanDirectories = lib.mkOption {
          type = with lib.types; listOf str;
          default = [
            "/home"
            "/var/lib"
            "/tmp"
            "/etc"
            "/var/tmp"
          ];
          description = ''
            List of directories to scan.
            The default includes everything I could think of that is valid for nixos. Feel free to contribute a PR to add to the default if you see something missing.
          '';
        };
      };
    };
  };

  config = lib.mkIf (cfg.updater.enable || cfg.daemon.enable) {
    environment.systemPackages = [ cfg.package ];

    users.users.${clamavUser} = {
      uid = config.ids.uids.clamav;
      group = clamavGroup;
      description = "ClamAV daemon user";
      home = stateDir;
    };

    users.groups.${clamavGroup} = {
      gid = config.ids.gids.clamav;
    };

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
      DEFAULT.db_url = lib.mkDefault "sqlite:////var/lib/clamav/fangfrisch_db.sqlite";
      DEFAULT.local_directory = lib.mkDefault stateDir;
      DEFAULT.log_level = lib.mkDefault "INFO";
      urlhaus.enabled = lib.mkDefault "yes";
      urlhaus.max_size = lib.mkDefault "2MB";
      sanesecurity.enabled = lib.mkDefault "yes";
    };

    environment.etc."clamav/freshclam.conf".source = freshclamConfigFile;
    environment.etc."clamav/clamd.conf".source = clamdConfigFile;

    systemd.slices.system-clamav = {
      description = "ClamAV Antivirus Slice";
    };

    systemd.services.clamav-daemon = lib.mkIf cfg.daemon.enable {
      description = "ClamAV daemon (clamd)";
      documentation = [ "man:clamd(8)" ];
      after = lib.optionals cfg.updater.enable [ "clamav-freshclam.service" ];
      wants = lib.optionals cfg.updater.enable [ "clamav-freshclam.service" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ clamdConfigFile ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/clamd";
        ExecReload = "${pkgs.coreutils}/bin/kill -USR2 $MAINPID";
        User = clamavUser;
        Group = clamavGroup;
        StateDirectory = "clamav";
        RuntimeDirectory = "clamav";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        PrivateNetwork = "yes";
        Slice = "system-clamav.slice";
      };
    };

    systemd.timers.clamav-freshclam = lib.mkIf cfg.updater.enable {
      description = "Timer for ClamAV virus database updater (freshclam)";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.updater.interval;
        Unit = "clamav-freshclam.service";
      };
    };

    systemd.services.clamav-freshclam = lib.mkIf cfg.updater.enable {
      description = "ClamAV virus database updater (freshclam)";
      documentation = [ "man:freshclam(1)" ];
      restartTriggers = [ freshclamConfigFile ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${cfg.package}/bin/freshclam";
        SuccessExitStatus = "1"; # if databases are up to date
        StateDirectory = "clamav";
        User = clamavUser;
        Group = clamavGroup;
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        Slice = "system-clamav.slice";
      };
    };

    systemd.services.clamav-fangfrisch-init = lib.mkIf cfg.fangfrisch.enable {
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
        Slice = "system-clamav.slice";
      };
    };

    systemd.timers.clamav-fangfrisch = lib.mkIf cfg.fangfrisch.enable {
      description = "Timer for ClamAV virus database updater (fangfrisch)";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.fangfrisch.interval;
        Unit = "clamav-fangfrisch.service";
      };
    };

    systemd.services.clamav-fangfrisch = lib.mkIf cfg.fangfrisch.enable {
      description = "ClamAV virus database updater (fangfrisch)";
      restartTriggers = [ fangfrischConfigFile ];
      requires = [ "network-online.target" ];
      after = [
        "network-online.target"
        "clamav-fangfrisch-init.service"
      ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.fangfrisch}/bin/fangfrisch --conf ${fangfrischConfigFile} refresh";
        StateDirectory = "clamav";
        User = clamavUser;
        Group = clamavGroup;
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        Slice = "system-clamav.slice";
      };
    };

    systemd.timers.clamdscan = lib.mkIf cfg.scanner.enable {
      description = "Timer for ClamAV virus scanner";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.scanner.interval;
        Unit = "clamdscan.service";
      };
    };

    systemd.services.clamdscan = lib.mkIf cfg.scanner.enable {
      description = "ClamAV virus scanner";
      documentation = [ "man:clamdscan(1)" ];
      after = lib.optionals cfg.updater.enable [ "clamav-freshclam.service" ];
      wants = lib.optionals cfg.updater.enable [ "clamav-freshclam.service" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${cfg.package}/bin/clamdscan --multiscan --fdpass --infected --allmatch ${lib.concatStringsSep " " cfg.scanner.scanDirectories}";
        Slice = "system-clamav.slice";
      };
    };
  };
}
