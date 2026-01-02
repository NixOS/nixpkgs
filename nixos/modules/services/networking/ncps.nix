{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.ncps;

  logLevels = [
    "trace"
    "debug"
    "info"
    "warn"
    "error"
    "fatal"
    "panic"
  ];

  globalFlags = lib.concatStringsSep " " (
    [ "--log-level='${cfg.logLevel}'" ]
    ++ (lib.optionals cfg.openTelemetry.enable (
      [
        "--otel-enabled"
      ]
      ++ (lib.optional (
        cfg.openTelemetry.grpcURL != null
      ) "--otel-grpc-url='${cfg.openTelemetry.grpcURL}'")
    ))
    ++ (lib.optionals cfg.prometheus.enable [
      "--prometheus-enabled"
    ])
  );

  serveFlags = lib.concatStringsSep " " (
    [
      "--cache-hostname='${cfg.cache.hostName}'"
      "--cache-data-path='${cfg.cache.dataPath}'"
      "--cache-database-url='${cfg.cache.databaseURL}'"
      "--cache-temp-path='${cfg.cache.tempPath}'"
      "--server-addr='${cfg.server.addr}'"
    ]
    ++ (lib.optional cfg.cache.allowDeleteVerb "--cache-allow-delete-verb")
    ++ (lib.optional cfg.cache.allowPutVerb "--cache-allow-put-verb")
    ++ (lib.optional (cfg.cache.maxSize != null) "--cache-max-size='${cfg.cache.maxSize}'")
    ++ (lib.optionals (cfg.cache.lru.schedule != null) [
      "--cache-lru-schedule='${cfg.cache.lru.schedule}'"
      "--cache-lru-schedule-timezone='${cfg.cache.lru.scheduleTimeZone}'"
    ])
    ++ (lib.optional (cfg.cache.secretKeyPath != null) "--cache-secret-key-path='%d/secretKey'")
    ++ (lib.optional (!cfg.cache.signNarinfo) "--cache-sign-narinfo='false'")
    ++ (lib.forEach cfg.upstream.caches (url: "--upstream-cache='${url}'"))
    ++ (lib.forEach cfg.upstream.publicKeys (pk: "--upstream-public-key='${pk}'"))
    ++ (lib.optional (cfg.netrcFile != null) "--netrc-file='${cfg.netrcFile}'")
  );

  isSqlite = lib.strings.hasPrefix "sqlite:" cfg.cache.databaseURL;

  dbPath = lib.removePrefix "sqlite:" cfg.cache.databaseURL;
  dbDir = dirOf dbPath;
in
{
  options = {
    services.ncps = {
      enable = lib.mkEnableOption "ncps: Nix binary cache proxy service implemented in Go";

      package = lib.mkPackageOption pkgs "ncps" { };

      dbmatePackage = lib.mkPackageOption pkgs "dbmate" { };

      openTelemetry = {
        enable = lib.mkEnableOption "Enable OpenTelemetry logs, metrics, and tracing";

        grpcURL = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Configure OpenTelemetry gRPC URL. Missing or "https" scheme enables
            secure gRPC, "insecure" otherwise. Omit to emit telemetry to
            stdout.
          '';
        };
      };

      prometheus.enable = lib.mkEnableOption "Enable Prometheus metrics endpoint at /metrics";

      logLevel = lib.mkOption {
        type = lib.types.enum logLevels;
        default = "info";
        description = ''
          Set the level for logging. Refer to
          <https://pkg.go.dev/github.com/rs/zerolog#readme-leveled-logging> for
          more information.
        '';
      };

      cache = {
        allowDeleteVerb = lib.mkEnableOption ''
          Whether to allow the DELETE verb to delete narinfo and nar files from
          the cache.
        '';

        allowPutVerb = lib.mkEnableOption ''
          Whether to allow the PUT verb to push narinfo and nar files directly
          to the cache.
        '';

        hostName = lib.mkOption {
          type = lib.types.str;
          description = ''
            The hostname of the cache server. **This is used to generate the
            private key used for signing store paths (.narinfo)**
          '';
        };

        dataPath = lib.mkOption {
          type = lib.types.str;
          default = "/var/lib/ncps";
          description = ''
            The local directory for storing configuration and cached store paths
          '';
        };

        databaseURL = lib.mkOption {
          type = lib.types.str;
          default = "sqlite:${cfg.cache.dataPath}/db/db.sqlite";
          defaultText = "sqlite:/var/lib/ncps/db/db.sqlite";
          description = ''
            The URL of the database (currently only SQLite is supported)
          '';
        };

        lru = {
          schedule = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "0 2 * * *";
            description = ''
              The cron spec for cleaning the store to keep it under
              config.ncps.cache.maxSize. Refer to
              https://pkg.go.dev/github.com/robfig/cron/v3#hdr-Usage for
              documentation.
            '';
          };

          scheduleTimeZone = lib.mkOption {
            type = lib.types.str;
            default = "Local";
            example = "America/Los_Angeles";
            description = ''
              The name of the timezone to use for the cron schedule. See
              <https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>
              for a comprehensive list of possible values for this setting.
            '';
          };
        };

        maxSize = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "100G";
          description = ''
            The maximum size of the store. It can be given with units such as
            5K, 10G etc. Supported units: B, K, M, G, T.
          '';
        };

        secretKeyPath = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            The path to load the secretKey for signing narinfos. Leave this
            empty to automatically generate a private/public key.
          '';
        };

        tempPath = lib.mkOption {
          type = lib.types.str;
          default = "/tmp";
          description = ''
            The path to the temporary directory that is used by the cache to download NAR files
          '';
        };

        signNarinfo = lib.mkOption {
          type = lib.types.bool;
          default = true;
          example = "false";
          description = ''
            Whether to sign narInfo files or passthru as-is from upstream
          '';
        };
      };

      server = {
        addr = lib.mkOption {
          type = lib.types.str;
          default = ":8501";
          description = ''
            The address and port the server listens on.
          '';
        };
      };

      upstream = {
        caches = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          example = [ "https://cache.nixos.org" ];
          description = ''
            A list of URLs of upstream binary caches.
          '';
        };

        publicKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
          description = ''
            A list of public keys of upstream caches in the format
            `host[-[0-9]*]:public-key`. This flag is used to verify the
            signatures of store paths downloaded from upstream caches.
          '';
        };
      };

      netrcFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/etc/nix/netrc";
        description = ''
          The path to netrc file for upstream authentication.
          When unspecified ncps will look for ``$HOME/.netrc`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.cache.lru.schedule == null || cfg.cache.maxSize != null;
        message = "You must specify config.ncps.cache.lru.schedule when config.ncps.cache.maxSize is set";
      }
    ];

    users.users.ncps = {
      isSystemUser = true;
      group = "ncps";
    };
    users.groups.ncps = { };

    systemd.services.ncps-create-directories = {
      description = "Created required directories by ncps";
      serviceConfig = {
        Type = "oneshot";
        UMask = "0066";
      };
      script =
        (lib.optionalString (cfg.cache.dataPath != "/var/lib/ncps") ''
          if ! test -d ${cfg.cache.dataPath}; then
            mkdir -p ${cfg.cache.dataPath}
            chown ncps:ncps ${cfg.cache.dataPath}
          fi
        '')
        + (lib.optionalString isSqlite ''
          if ! test -d ${dbDir}; then
            mkdir -p ${dbDir}
            chown ncps:ncps ${dbDir}
          fi
        '')
        + (lib.optionalString (cfg.cache.tempPath != "/tmp") ''
          if ! test -d ${cfg.cache.tempPath}; then
            mkdir -p ${cfg.cache.tempPath}
            chown ncps:ncps ${cfg.cache.tempPath}
          fi
        '');
      wantedBy = [ "ncps.service" ];
      before = [ "ncps.service" ];
    };

    systemd.services.ncps = {
      description = "ncps binary cache proxy service";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        ${lib.getExe cfg.dbmatePackage} --migrations-dir=${cfg.package}/share/ncps/db/migrations --url=${cfg.cache.databaseURL} up
      '';

      serviceConfig = lib.mkMerge [
        {
          ExecStart = "${lib.getExe cfg.package} ${globalFlags} serve ${serveFlags}";
          User = "ncps";
          Group = "ncps";
          Restart = "on-failure";
          RuntimeDirectory = "ncps";
        }

        # credentials
        (lib.mkIf (cfg.cache.secretKeyPath != null) {
          LoadCredential = "secretKey:${cfg.cache.secretKeyPath}";
        })

        # ensure permissions on required directories
        (lib.mkIf (cfg.cache.dataPath != "/var/lib/ncps") {
          ReadWritePaths = [ cfg.cache.dataPath ];
        })
        (lib.mkIf (cfg.cache.dataPath == "/var/lib/ncps") {
          StateDirectory = "ncps";
          StateDirectoryMode = "0700";
        })
        (lib.mkIf (isSqlite && !lib.strings.hasPrefix "/var/lib/ncps" dbDir) {
          ReadWritePaths = [ dbDir ];
        })
        (lib.mkIf (cfg.cache.tempPath != "/tmp") {
          ReadWritePaths = [ cfg.cache.tempPath ];
        })

        # Hardening
        {
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          CapabilityBoundingSet = "";
          PrivateUsers = true;
          DevicePolicy = "closed";
          DeviceAllow = [ "" ];
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          ProtectHome = true;
          RestrictSUIDSGID = true;
          RestrictRealtime = true;
          MemoryDenyWriteExecute = true;
          ProcSubset = "pid";
          RestrictNamespaces = true;
          SystemCallArchitectures = "native";
          PrivateNetwork = false;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateMounts = true;
          NoNewPrivileges = true;
          LockPersonality = true;
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
          LimitNOFILE = 65536;
          UMask = "0066";
        }
      ];

      unitConfig.RequiresMountsFor = lib.concatStringsSep " " (
        [ "${cfg.cache.dataPath}" ] ++ lib.optional isSqlite dbDir
      );
    };
  };

  meta.maintainers = with lib.maintainers; [
    kalbasit
    aciceri
  ];
}
