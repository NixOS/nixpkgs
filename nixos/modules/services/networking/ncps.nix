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

  ncpsWrapper = pkgs.writeShellScript "ncps-wrapper" ''
    ${lib.optionalString (cfg.cache.storage.s3 != null) ''
      export CACHE_STORAGE_S3_ACCESS_KEY_ID="$(cat "$CREDENTIALS_DIRECTORY/s3AccessKeyId")"
      export CACHE_STORAGE_S3_SECRET_ACCESS_KEY="$(cat "$CREDENTIALS_DIRECTORY/s3SecretAccessKey")"
    ''}

    ${lib.optionalString (cfg.cache.redis != null && cfg.cache.redis.passwordFile != null) ''
      export CACHE_REDIS_PASSWORD="$(cat "$CREDENTIALS_DIRECTORY/redisPassword")"
    ''}

    ${lib.optionalString (cfg.cache.databaseURLFile != null) ''
      export CACHE_DATABASE_URL="$(cat "$CREDENTIALS_DIRECTORY/databaseURL")"
    ''}

    exec ${lib.getExe cfg.package} "$@"
  '';

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
    ++ (lib.optional cfg.prometheus.enable "--prometheus-enabled")
    ++ (lib.optional (!cfg.analytics.reporting.enable) "--analytics-reporting-enabled=false")
  );

  serveFlags = lib.concatStringsSep " " (
    [
      "--cache-hostname='${cfg.cache.hostName}'"
      "--cache-lock-backend='${cfg.cache.lock.backend}'"
      "--cache-temp-path='${cfg.cache.tempPath}'"
      "--server-addr='${cfg.server.addr}'"
    ]
    ++ (lib.optional (cfg.cache.databaseURL != null) "--cache-database-url='${cfg.cache.databaseURL}'")
    ++ (lib.optionals (cfg.cache.redis != null) (
      [
        "--cache-redis-addrs='${builtins.concatStringsSep "," cfg.cache.redis.addresses}'"
        "--cache-redis-db='${builtins.toString cfg.cache.redis.database}'"
        "--cache-redis-pool-size='${builtins.toString cfg.cache.redis.poolSize}'"
      ]
      ++ (lib.optional (
        cfg.cache.redis.username != null
      ) "--cache-redis-username='${cfg.cache.redis.username}'")
      ++ (lib.optional (
        cfg.cache.redis.password != null
      ) "--cache-redis-password='${cfg.cache.redis.password}'")
      ++ (lib.optional cfg.cache.redis.useTLS "--cache-redis-use-tls")
    ))
    ++ (lib.optional (
      cfg.cache.storage.s3 == null
    ) "--cache-storage-local='${cfg.cache.storage.local}'")
    ++ (lib.optionals (cfg.cache.storage.s3 != null) (
      [
        "--cache-storage-s3-bucket='${cfg.cache.storage.s3.bucket}'"
        "--cache-storage-s3-endpoint='${cfg.cache.storage.s3.endpoint}'"
      ]
      ++ (lib.optional cfg.cache.storage.s3.forcePathStyle "--cache-storage-s3-force-path-style")
      ++ (lib.optional (
        cfg.cache.storage.s3.region != null
      ) "--cache-storage-s3-region='${cfg.cache.storage.s3.region}'")
    ))
    ++ (lib.optional cfg.cache.allowDeleteVerb "--cache-allow-delete-verb")
    ++ (lib.optional cfg.cache.allowPutVerb "--cache-allow-put-verb")
    ++ (lib.optional (cfg.cache.maxSize != null) "--cache-max-size='${cfg.cache.maxSize}'")
    ++ (lib.optionals (cfg.cache.lru.schedule != null) [
      "--cache-lru-schedule='${cfg.cache.lru.schedule}'"
      "--cache-lru-schedule-timezone='${cfg.cache.lru.scheduleTimeZone}'"
    ])
    ++ (lib.optional (cfg.cache.secretKeyPath != null) "--cache-secret-key-path='%d/secretKey'")
    ++ (lib.optional (!cfg.cache.signNarinfo) "--cache-sign-narinfo='false'")
    ++ (lib.optional (
      cfg.cache.upstream.dialerTimeout != null
    ) "--cache-upstream-dialer-timeout='${cfg.cache.upstream.dialerTimeout}'")
    ++ (lib.optional (
      cfg.cache.upstream.responseHeaderTimeout != null
    ) "--cache-upstream-response-header-timeout='${cfg.cache.upstream.responseHeaderTimeout}'")
    ++ (lib.forEach cfg.cache.upstream.publicKeys (pk: "--cache-upstream-public-key='${pk}'"))
    ++ (lib.forEach cfg.cache.upstream.urls (url: "--cache-upstream-url='${url}'"))
    ++ (lib.optional (cfg.netrcFile != null) "--netrc-file='${cfg.netrcFile}'")
  );

  isSqlite = cfg.cache.databaseURL != null && lib.strings.hasPrefix "sqlite:" cfg.cache.databaseURL;

  dbPath = if isSqlite then lib.removePrefix "sqlite:" cfg.cache.databaseURL else null;
  dbDir = if isSqlite then dirOf dbPath else null;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "ncps" "cache" "dataPath" ]
      [ "services" "ncps" "cache" "storage" "local" ]
    )

    (lib.mkRenamedOptionModule
      [ "services" "ncps" "upstream" "caches" ]
      [ "services" "ncps" "cache" "upstream" "urls" ]
    )

    (lib.mkRenamedOptionModule
      [ "services" "ncps" "upstream" "publicKeys" ]
      [ "services" "ncps" "cache" "upstream" "publicKeys" ]
    )

    (lib.mkRemovedOptionModule [
      "services"
      "ncps"
      "dbmatePackage"
    ] "dbmate is now wrapped within ncps package, you need to override ncps to change dbmate package")
  ];

  options = {
    services.ncps = {
      enable = lib.mkEnableOption "ncps: Nix binary cache proxy service implemented in Go";

      analytics.reporting.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable reporting anonymous usage statistics (DB type, Lock type, Total Size) to the project maintainers.
        '';
      };

      package = lib.mkPackageOption pkgs "ncps" { };

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

        databaseURL = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "sqlite:${cfg.cache.storage.local}/db/db.sqlite";
          defaultText = "sqlite:/var/lib/ncps/db/db.sqlite";
          description = ''
            The URL of the database (currently only SQLite is supported)
          '';
        };

        databaseURLFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            File containing the URL of the database.
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

        lock.backend = lib.mkOption {
          type = lib.types.enum [
            "local"
            "redis"
          ];
          default = "local";
          description = ''
            Lock backend to use: 'local' (single instance), 'redis' (distributed).
          '';
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

        redis = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.submodule {
              options = {
                addresses = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  example = ''
                    ["redis0:6379" "redis1:6379"]
                  '';
                  description = ''
                    A list of host:port for the Redis servers that are part of a cluster.
                    To use a single Redis instance, just set this to its single address.
                  '';
                };

                database = lib.mkOption {
                  type = lib.types.int;
                  default = 0;
                  description = ''
                    Redis database number (0-15)
                  '';
                };

                username = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = ''
                    Redis username for authentication (for Redis ACL).
                  '';
                };

                password = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = ''
                    Redis password for authentication (for Redis ACL).
                  '';
                };

                passwordFile = lib.mkOption {
                  type = lib.types.nullOr lib.types.path;
                  default = null;
                  description = ''
                    File containing the redis password for authentication (for Redis ACL).
                  '';
                };

                poolSize = lib.mkOption {
                  type = lib.types.int;
                  default = 10;
                  description = ''
                    Redis connection pool size.
                  '';
                };

                useTLS = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = ''
                    Use TLS for Redis connection.
                  '';
                };
              };
            }
          );

          default = null;

          description = ''
            Configure Redis.
          '';
        };

        secretKeyPath = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            The path to load the secretKey for signing narinfos. Leave this
            empty to automatically generate a private/public key.
          '';
        };

        storage = {
          local = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/ncps";
            description = ''
              The local directory for storing configuration and cached store
              paths. This is ignored if services.ncps.cache.storage.s3 is not
              null.
            '';
          };

          s3 = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  bucket = lib.mkOption {
                    type = lib.types.str;
                    description = ''
                      The name of the S3 bucket.
                    '';
                  };

                  endpoint = lib.mkOption {
                    type = lib.types.str;
                    description = ''
                      S3-compatible endpoint URL with scheme.
                    '';
                    example = "https://s3.amazonaws.com";
                  };

                  forcePathStyle = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                    description = ''
                      Force path-style S3 addressing (bucket/key vs key.bucket).
                    '';
                  };

                  region = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = ''
                      The S3 region.
                    '';
                  };

                  accessKeyIdPath = lib.mkOption {
                    type = lib.types.path;
                    description = ''
                      The path to a file containing only the access-key-id.
                    '';
                  };

                  secretAccessKeyPath = lib.mkOption {
                    type = lib.types.path;
                    description = ''
                      The path to a file containing only the secret-access-key.
                    '';
                  };
                };
              }
            );
            default = null;
            description = ''
              Use S3 for storage instead of local storage.
            '';
          };
        };

        tempPath = lib.mkOption {
          type = lib.types.path;
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

        upstream = {
          dialerTimeout = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Timeout for establishing TCP connections to upstream caches (e.g., 3s, 5s, 10s).
            '';
          };

          responseHeaderTimeout = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "5s";
            description = ''
              Timeout for waiting for upstream server's response headers.
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

          urls = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            example = [ "https://cache.nixos.org" ];
            description = ''
              A list of URLs of upstream binary caches.
            '';
          };
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

      netrcFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
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
        assertion = lib.xor (cfg.cache.databaseURL != null) (cfg.cache.databaseURLFile != null);
        message = "You must specify exactly one of config.ncps.cache.databaseURL or config.ncps.cache.databaseURLFile";
      }
      {
        assertion = cfg.cache.lru.schedule == null || cfg.cache.maxSize != null;
        message = "You must specify config.ncps.cache.lru.schedule when config.ncps.cache.maxSize is set";
      }
      {
        assertion =
          cfg.cache.redis == null || cfg.cache.redis.password == null || cfg.cache.redis.passwordFile == null;
        message = "You cannot specify both config.ncps.cache.redis.password and config.ncps.cache.redis.passwordFile";
      }
      {
        assertion = cfg.cache.lock.backend == "redis" -> cfg.cache.redis != null;
        message = "You must specify config.ncps.cache.redis when config.ncps.cache.lock.backend is set to 'redis'";
      }
      {
        assertion = cfg.cache.redis != null -> cfg.cache.lock.backend == "redis";
        message = "You must set config.ncps.cache.lock.backend to 'redis' when config.ncps.cache.redis is set";
      }
    ];

    users.users.ncps = {
      isSystemUser = true;
      group = "ncps";
    };
    users.groups.ncps = { };

    systemd.tmpfiles.settings.ncps =
      let
        perms = {
          group = "ncps";
          mode = "0700";
          user = "ncps";
        };
      in
      lib.mkMerge [
        (lib.mkIf (cfg.cache.storage.s3 == null && cfg.cache.storage.local != "/var/lib/ncps") {
          "${cfg.cache.storage.local}".d = perms;
        })

        (lib.mkIf isSqlite { "${dbDir}".d = perms; })

        (lib.mkIf (cfg.cache.tempPath != "/tmp") { "${cfg.cache.tempPath}".d = perms; })
      ];

    systemd.services.ncps = {
      description = "ncps binary cache proxy service";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        ${lib.optionalString (cfg.cache.databaseURLFile != null) ''
          export DATABASE_URL="$(cat "$CREDENTIALS_DIRECTORY/databaseURL")"
        ''}
        ${lib.optionalString (cfg.cache.databaseURL != null) ''
          export DATABASE_URL="${cfg.cache.databaseURL}"
        ''}
        echo ${cfg.package}/bin/dbmate-ncps up
        ${cfg.package}/bin/dbmate-ncps up
      '';

      serviceConfig = lib.mkMerge [
        {
          ExecStart = "${ncpsWrapper} ${globalFlags} serve ${serveFlags}";
          User = "ncps";
          Group = "ncps";
          Restart = "on-failure";
          RuntimeDirectory = "ncps";
        }

        # credentials for cache.secretKeyPath
        (lib.mkIf (cfg.cache.secretKeyPath != null) {
          LoadCredential = lib.singleton "secretKey:${cfg.cache.secretKeyPath}";
        })

        # credentials for cache.storage.s3 accessKeyIdPath and secretAccessKeyPath
        (lib.mkIf (cfg.cache.storage.s3 != null) {
          LoadCredential = [
            "s3AccessKeyId:${cfg.cache.storage.s3.accessKeyIdPath}"
            "s3SecretAccessKey:${cfg.cache.storage.s3.secretAccessKeyPath}"
          ];
        })

        # credentials for Redis
        (lib.mkIf (cfg.cache.redis != null && cfg.cache.redis.passwordFile != null) {
          LoadCredential = lib.singleton "redisPassword:${cfg.cache.redis.passwordFile}";
        })

        (lib.mkIf (cfg.cache.databaseURLFile != null) {
          LoadCredential = lib.singleton "databaseURL:${cfg.cache.databaseURLFile}";
        })

        # ensure permissions on required directories
        (lib.mkIf (cfg.cache.storage.s3 == null && cfg.cache.storage.local != "/var/lib/ncps") {
          ReadWritePaths = [ cfg.cache.storage.local ];
        })
        (lib.mkIf (cfg.cache.storage.s3 == null && cfg.cache.storage.local == "/var/lib/ncps") {
          StateDirectory = "ncps";
          StateDirectoryMode = "0700";
        })
        (lib.mkIf (cfg.cache.storage.s3 != null && isSqlite && lib.strings.hasPrefix "/var/lib/ncps" dbDir)
          {
            StateDirectory = "ncps";
            StateDirectoryMode = "0700";
          }
        )
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
        (lib.optional (cfg.cache.storage.s3 == null) "${cfg.cache.storage.local}")
        ++ (lib.optional isSqlite dbDir)
      );
    };
  };

  meta.maintainers = with lib.maintainers; [
    kalbasit
    aciceri
  ];
}
