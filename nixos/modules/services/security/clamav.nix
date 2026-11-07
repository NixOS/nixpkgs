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

  # What fangfrisch's configuration parser treats as false (see means_disabled).
  isFangfrischDisabled =
    v:
    v == false
    || v == 0
    || (
      lib.isString v
      && lib.elem (lib.toLower v) [
        "0"
        "disabled"
        "false"
        "no"
        "off"
      ]
    );

  clamdConfigFile = pkgs.writeText "clamd.conf" (toKeyValue cfg.daemon.settings);
  freshclamConfigFile = pkgs.writeText "freshclam.conf" (toKeyValue cfg.updater.settings);
  fangfrischConfigFile = pkgs.writeText "fangfrisch.conf" ''
    ${lib.generators.toINI { } cfg.fangfrisch.settings}
  '';

  # fangfrisch has no `*_file` settings, so the URLhaus key has to be written into
  # a runtime copy of the configuration rather than into the store.
  urlhausAuthKeyFile = cfg.fangfrisch.urlhaus.authKeyFile;
  useUrlhausAuthKey = cfg.fangfrisch.urlhaus.enable && urlhausAuthKeyFile != null;
  fangfrischConfig =
    if useUrlhausAuthKey then "$RUNTIME_DIRECTORY/fangfrisch.conf" else "${fangfrischConfigFile}";

  fangfrischConfigScript = pkgs.writeShellScript "clamav-fangfrisch-config" ''
    set -euo pipefail
    umask 0077

    ${lib.getExe pkgs.gawk} -v keyfile="$CREDENTIALS_DIRECTORY/urlhaus-auth-key" '
      BEGIN {
        getline auth_key < keyfile
        close(keyfile)
      }

      /^\[urlhaus\]$/ {
        print
        print "auth_key = " auth_key
        in_urlhaus = 1
        next
      }

      /^\[/ {
        in_urlhaus = 0
      }

      in_urlhaus && /^[[:space:]]*auth_key[[:space:]]*=/ {
        next
      }

      { print }
    ' ${fangfrischConfigFile} > ${fangfrischConfig}
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

      clamonacc = {
        enable = lib.mkOption {
          default = false;
          example = true;
          description = ''
            Whether to enable ClamAV on-access scanner.

            The settings for ClamAV's on-access scanner is configured in `clamd.conf` via `services.clamav.daemon.settings`.
            Refer to <https://docs.clamav.net/manual/OnAccess.html> on how to configure it.

            Example to scan `/home/foo/Downloads` (and block access until scanning is completed) would be:
            ```
            services.clamav = {
              daemon.enable = true;
              clamonacc.enable = true;

              daemon.settings = {
                OnAccessPrevention = true;
                OnAccessIncludePath = "/home/foo/Downloads";
              };
            };
            ```
          '';
          type = lib.types.bool;
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
            How often fangfrisch is invoked. See {manpage}`systemd.time(7)` for more
            information about the format.
          '';
        };

        urlhaus = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = cfg.fangfrisch.urlhaus.authKeyFile != null;
            defaultText = lib.literalExpression "config.services.clamav.fangfrisch.urlhaus.authKeyFile != null";
            example = true;
            description = ''
              Whether to enable the URLhaus signature provider. This only
              provides the default for
              {option}`services.clamav.fangfrisch.settings.urlhaus.enabled`, so an
              explicit value there wins; enabling the provider here while
              disabling it in the settings is an evaluation error.
            '';
          };

          authKeyFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            example = "/run/secrets/urlhaus-auth-key";
            description = ''
              File containing a personal URLhaus authentication key, obtainable
              from <https://urlhaus.abuse.ch/>. fangfrisch requires such a key
              since version 1.9.3.

              The file is passed to the service with systemd's `LoadCredential=`
              and only ever written to a runtime copy of the configuration, never
              to the Nix store. Setting this enables
              {option}`services.clamav.fangfrisch.urlhaus.enable`.

              Note that fangfrisch logs the full request URL when a download
              fails, and the key is part of that URL, so an invalid or expired
              key ends up in the journal. Keep that in mind when the journal is
              shipped off-host.
            '';
          };
        };

        sanesecurity = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            example = true;
            description = "Whether to enable the Sanesecurity signature provider.";
          };
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

            The Sanesecurity provider is enabled by default. The URLhaus provider
            is enabled when {option}`services.clamav.fangfrisch.urlhaus.authKeyFile`
            is set. The URLhaus export may exceed fangfrisch's default 10 MiB size
            limit, in which case `urlhaus.max_size` has to be raised.

            Values set here end up world-readable in the Nix store, so URLhaus
            keys belong in {option}`services.clamav.fangfrisch.urlhaus.authKeyFile`
            rather than in `urlhaus.auth_key`.
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
    assertions = [
      {
        assertion = cfg.scanner.enable -> cfg.daemon.enable;
        message = "ClamAV scanner requires ClamAV daemon to operate";
      }
      {
        assertion = cfg.clamonacc.enable -> cfg.daemon.enable;
        message = "ClamAV on-access scanner requires ClamAV daemon to operate";
      }
      {
        assertion = !cfg.fangfrisch.urlhaus.enable || urlhausAuthKeyFile != null;
        message = ''
          The URLhaus provider requires an authentication key. Set
          services.clamav.fangfrisch.urlhaus.authKeyFile, or disable the provider
          with services.clamav.fangfrisch.urlhaus.enable = false.
        '';
      }
      {
        assertion =
          !cfg.fangfrisch.urlhaus.enable || !(isFangfrischDisabled cfg.fangfrisch.settings.urlhaus.enabled);
        message = ''
          services.clamav.fangfrisch.urlhaus.enable is enabled, but
          services.clamav.fangfrisch.settings.urlhaus.enabled is set to a disabled
          value. Settings take precedence over the option; remove the settings
          entry or set services.clamav.fangfrisch.urlhaus.enable = false.
        '';
      }
    ];

    warnings =
      lib.optional
        (cfg.daemon.enable && (cfg.daemon.settings ? TCPSocket || cfg.daemon.settings ? TCPAddr))
        ''
          services.clamav.daemon: `TCPSocket`/`TCPAddr` in `settings` have no effect.
          clamd is started via systemd socket activation (the clamav-daemon.socket unit
          passes it only the LocalSocket), and a socket-activated clamd uses only the file
          descriptors it receives, ignoring the LocalSocket/TCPSocket/TCPAddr directives in
          clamd.conf -- so clamd never listens on the configured TCP port. Connect via the
          unix socket (services.clamav.daemon.settings.LocalSocket), or expose TCP by adding
          it to the socket unit, e.g.
            systemd.sockets.clamav-daemon.listenStreams = [ "127.0.0.1:3310" ];
          (as Debian's packaging does). See https://bugs.debian.org/771911
        '';

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
      User = clamavUser;
      Foreground = true;
      # Prevent infinite recursion in scanning
      OnAccessExcludeUname = clamavUser;
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
      urlhaus.enabled = lib.mkDefault (if cfg.fangfrisch.urlhaus.enable then "yes" else "no");
      sanesecurity.enabled = lib.mkDefault (if cfg.fangfrisch.sanesecurity.enable then "yes" else "no");
    };

    environment.etc."clamav/freshclam.conf".source = freshclamConfigFile;
    environment.etc."clamav/clamd.conf".source = clamdConfigFile;

    systemd.slices.system-clamav = {
      description = "ClamAV Antivirus Slice";
    };

    systemd.sockets.clamav-daemon = lib.mkIf cfg.daemon.enable {
      description = "Socket for ClamAV daemon (clamd)";
      wantedBy = [ "sockets.target" ];
      listenStreams = [
        cfg.daemon.settings.LocalSocket
      ];
      socketConfig = {
        SocketUser = clamavUser;
        SocketGroup = clamavGroup;
        # LocalSocketMode setting in clamd.conf is not prefixed with octal 0, add it here.
        SocketMode = "0${cfg.daemon.settings.LocalSocketMode or "666"}";
      };
    };

    systemd.services.clamav-daemon = lib.mkIf cfg.daemon.enable {
      description = "ClamAV daemon (clamd)";
      documentation = [ "man:clamd(8)" ];
      after = lib.optionals cfg.updater.enable [ "clamav-freshclam.service" ];
      wants = lib.optionals cfg.updater.enable [ "clamav-freshclam.service" ];
      requires = [ "clamav-daemon.socket" ];
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

    systemd.services.clamav-clamonacc = lib.mkIf cfg.clamonacc.enable {
      description = "ClamAV on-access scanner (clamonacc)";
      after = [ "clamav-daemon.socket" ];
      requires = [ "clamav-daemon.socket" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ clamdConfigFile ];

      # This unit must start as root to be able to use fanotify.
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/clamonacc -F --fdpass";
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

      serviceConfig = lib.mkMerge [
        {
          Type = "oneshot";
          ExecStart = "${pkgs.fangfrisch}/bin/fangfrisch --conf ${fangfrischConfig} refresh";
          StateDirectory = "clamav";
          User = clamavUser;
          Group = clamavGroup;
          PrivateTmp = "yes";
          PrivateDevices = "yes";
          Slice = "system-clamav.slice";
        }
        (lib.mkIf useUrlhausAuthKey {
          ExecStartPre = fangfrischConfigScript;
          LoadCredential = "urlhaus-auth-key:${urlhausAuthKeyFile}";
          RuntimeDirectory = "clamav-fangfrisch";
          RuntimeDirectoryMode = "0700";
        })
      ];
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
