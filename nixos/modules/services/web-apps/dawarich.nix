{
  lib,
  pkgs,
  config,
  options,
  ...
}:

let
  cfg = config.services.dawarich;
  opt = options.services.dawarich;

  # We only want to create a Redis and PostgreSQL databases if we're actually going to connect to it local.
  redisActuallyCreateLocally =
    cfg.redis.createLocally && (cfg.redis.host == "127.0.0.1" || cfg.redis.enableUnixSocket);
  databaseActuallyCreateLocally =
    cfg.database.createLocally && cfg.database.host == "/run/postgresql";

  env =
    {
      RAILS_ENV = "production";
      NODE_ENV = "production";

      SELF_HOSTED = "true";
      STORE_GEODATA = "true";
      APPLICATION_PROTOCOL = "http";
      TIME_ZONE = config.time.timeZone; # otherwise upstream forces it to Europe/London

      # BOOTSNAP_CACHE_DIR = "/var/cache/mastodon/precompile";
      LD_PRELOAD = "${pkgs.jemalloc}/lib/libjemalloc.so";

      # Concurrency mastodon-web
      # WEB_CONCURRENCY = toString cfg.webProcesses;
      # MAX_THREADS = toString cfg.webThreads;

      DATABASE_USER = cfg.database.user;
      DATABASE_HOST = cfg.database.host;
      DATABASE_NAME = cfg.database.name;

      # SMTP_SERVER = cfg.smtp.host;
      # SMTP_PORT = toString cfg.smtp.port;
      # SMTP_FROM_ADDRESS = cfg.smtp.fromAddress;

      # TRUSTED_PROXY_IP = cfg.trustedProxy;

      # TODO: add option!!
      SECRET_KEY_BASE = "1234567890";
    }
    # TODO: we need to construct a REDIS_URL
    # // lib.optionalAttrs (cfg.redis.host != null) { REDIS_HOST = cfg.redis.host; }
    # // lib.optionalAttrs (cfg.redis.port != null) { REDIS_PORT = toString cfg.redis.port; }
    // lib.optionalAttrs (cfg.redis.createLocally && cfg.redis.enableUnixSocket) {
      REDIS_URL = "unix://${config.services.redis.servers.dawarich.unixSocket}";
    }
    // lib.optionalAttrs (cfg.database.host != "/run/postgresql" && cfg.database.port != null) {
      DATABASE_PORT = toString cfg.database.port;
    }
    # // lib.optionalAttrs cfg.smtp.authenticate { SMTP_LOGIN = cfg.smtp.user; }
    // cfg.extraConfig;

  systemCallsList = [
    "@cpu-emulation"
    "@debug"
    "@keyring"
    "@ipc"
    "@mount"
    "@obsolete"
    "@privileged"
    "@setuid"
  ];

  cfgService = {
    # User and group
    User = cfg.user;
    Group = cfg.group;
    # Working directory
    WorkingDirectory = cfg.package;
    # Cache directory and mode
    CacheDirectory = "dawarich";
    CacheDirectoryMode = "0750";
    # State directory and mode
    StateDirectory = "dawarich";
    StateDirectoryMode = "0750";
    # Logs directory and mode
    LogsDirectory = "dawarich";
    LogsDirectoryMode = "0750";
    # Proc filesystem
    ProcSubset = "pid";
    ProtectProc = "invisible";
    # Access write directories
    UMask = "0027";
    # Capabilities
    CapabilityBoundingSet = "";
    # Security
    NoNewPrivileges = true;
    # Sandboxing
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    PrivateUsers = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectControlGroups = true;
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
      "AF_NETLINK"
    ];
    RestrictNamespaces = true;
    LockPersonality = true;
    MemoryDenyWriteExecute = false;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RemoveIPC = true;
    PrivateMounts = true;
    # System Call Filtering
    SystemCallArchitectures = "native";
  };

  # Units that all Dawarich units After= and Requires= on
  commonUnits =
    lib.optional redisActuallyCreateLocally "redis-dawarich.service"
    ++ lib.optional databaseActuallyCreateLocally "postgresql.target"
    ++ lib.optional cfg.automaticMigrations "dawarich-init-db.service";

  sidekiqUnits = lib.attrsets.mapAttrs' (
    name: processCfg:
    lib.nameValuePair "dawarich-sidekiq-${name}" (
      let
        jobClassArgs = toString (builtins.map (c: "-q ${c}") processCfg.jobClasses);
        jobClassLabel = toString ([ "" ] ++ processCfg.jobClasses);
        threads = toString (if processCfg.threads == null then cfg.sidekiqThreads else processCfg.threads);
      in
      {
        after = [
          "network.target"
        ] ++ commonUnits;
        requires = commonUnits;
        description = "Dawarich sidekiq${jobClassLabel}";
        wantedBy = [ "dawarich.target" ];
        environment = env // {
          DB_POOL = threads; # TODO?
        };
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/sidekiq ${jobClassArgs} -c ${threads} -r ${cfg.package}";
          Restart = "always";
          RestartSec = 20;
          EnvironmentFile = cfg.extraEnvFiles;
          WorkingDirectory = cfg.package;
          LimitNOFILE = "1024000";
          # System Call Filtering
          SystemCallFilter = [
            ("~" + lib.concatStringsSep " " systemCallsList)
            "@chown"
            "pipe"
            "pipe2"
          ];
        } // cfgService;
      }
    )
  ) cfg.sidekiqProcesses;

in
{

  options = {
    services.dawarich = {
      enable = lib.mkEnableOption "Dawarich, a self-hostable alternative to Google Location History";

      configureNginx = lib.mkOption {
        # TODO
        description = ''
          Configure nginx as a reverse proxy for dawarich.
          Note that this makes some assumptions on your setup, and sets settings that will
          affect other virtualHosts running on your nginx instance, if any.
          Alternatively you can configure a reverse-proxy of your choice to serve these paths:

          `/ -> ''${pkgs.mastodon}/public`

          `/ -> 127.0.0.1:{{ webPort }} `(If there was no file in the directory above.)

          `/system/ -> /var/lib/mastodon/public-system/`

          `/api/v1/streaming/ -> 127.0.0.1:{{ streamingPort }}`

          Make sure that websockets are forwarded properly. You might want to set up caching
          of some requests. Take a look at mastodon's provided nginx configuration at
          `https://github.com/mastodon/mastodon/blob/master/dist/nginx.conf`.
        '';
        type = lib.types.bool;
        default = false;
      };

      user = lib.mkOption {
        description = ''
          User under which dawarich runs. If it is set to "dawarich",
          that user will be created, otherwise it should be set to the
          name of a user created elsewhere.
        '';
        type = lib.types.str;
        default = "dawarich";
      };

      group = lib.mkOption {
        description = ''
          Group under which dawarich runs.
        '';
        type = lib.types.str;
        default = "dawarich";
      };

      webPort = lib.mkOption {
        description = "TCP port used by the dawarich web service.";
        type = lib.types.port;
        default = 3000;
      };

      sidekiqThreads = lib.mkOption {
        description = ''
          Worker threads used by the dawarich-sidekiq-all service.
          If `sidekiqProcesses` is configured and any processes specify null `threads`, this value is used.
        '';
        type = lib.types.int;
        default = 5;
      };

      sidekiqProcesses = lib.mkOption {
        description = ''
          How many Sidekiq processes should be used to handle background jobs, and which job classes they handle.
          Can be used to [speed up](https://dawarich.app/docs/FAQ/#how-to-speed-up-the-import-process) the import process.
        '';
        type =
          with lib.types;
          attrsOf (submodule {
            options = {
              jobClasses = lib.mkOption {
                type = listOf (enum [
                  "points"
                  "default"
                  "imports"
                  "exports"
                  "stats"
                  "reverse_geocoding"
                  "visit_suggesting"
                ]);
                description = ''
                  If not empty, which job classes should be executed by this process.
                  *If left empty, all job classes will be executed by this process.*
                '';
              };
              threads = lib.mkOption {
                type = nullOr int;
                description = ''
                  Number of threads this process should use for executing jobs.
                  If null, the configured `sidekiqThreads` are used.
                '';
              };
            };
          });
        default = {
          all = {
            jobClasses = [ ];
            threads = null;
          };
        };
        example = {
          all = {
            jobClasses = [ ];
            threads = null;
          };
          geocoding = {
            jobClasses = [ "reverse_geocoding" ];
            threads = 10;
          };
        };
      };

      # TODO
      localDomain = lib.mkOption {
        description = "The domain serving your Dawarich instance.";
        example = "social.example.org";
        type = lib.types.str;
      };

      # TODO
      trustedProxy = lib.mkOption {
        description = ''
          You need to set it to the IP from which your reverse proxy sends requests to Dawarich's web process,
          otherwise Dawarich will record the reverse proxy's own IP as the IP of all requests, which would be
          bad because IP addresses are used for important rate limits and security functions.
        '';
        type = lib.types.str;
        default = "127.0.0.1";
      };

      # TODO
      enableUnixSocket = lib.mkOption {
        description = ''
          Instead of binding to an IP address like 127.0.0.1, you may bind to a Unix socket. This variable
          is process-specific, e.g. you need different values for every process, and it works for both web (Puma)
          processes and streaming API (Node.js) processes.
        '';
        type = lib.types.bool;
        default = true;
      };

      redis = {
        createLocally = lib.mkOption {
          description = "Configure local Redis server for Dawarich.";
          type = lib.types.bool;
          default = true;
        };

        host = lib.mkOption {
          description = "Redis host.";
          type = lib.types.nullOr lib.types.str;
          default = if cfg.redis.createLocally && !cfg.redis.enableUnixSocket then "127.0.0.1" else null;
          defaultText = lib.literalExpression ''
            if config.${opt.redis.createLocally} && !config.${opt.redis.enableUnixSocket} then "127.0.0.1" else null
          '';
        };

        port = lib.mkOption {
          description = "Redis port.";
          type = lib.types.nullOr lib.types.port;
          default = if cfg.redis.createLocally && !cfg.redis.enableUnixSocket then 31637 else null;
          defaultText = lib.literalExpression ''
            if config.${opt.redis.createLocally} && !config.${opt.redis.enableUnixSocket} then 31637 else null
          '';
        };

        passwordFile = lib.mkOption {
          description = "A file containing the password for Redis database.";
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/dawarich-redis-password";
        };

        enableUnixSocket = lib.mkOption {
          description = "Use Unix socket";
          type = lib.types.bool;
          default = true;
        };
      };

      database = {
        createLocally = lib.mkOption {
          description = "Configure local PostgreSQL database server for Dawarich.";
          type = lib.types.bool;
          default = true;
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "/run/postgresql";
          example = "192.168.23.42";
          description = "Database host address or unix socket.";
        };

        port = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = if cfg.database.createLocally then null else 5432;
          defaultText = lib.literalExpression ''
            if config.${opt.database.createLocally}
            then null
            else 5432
          '';
          description = "Database host port.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "dawarich";
          description = "Database name.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "dawarich";
          description = "Database user.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/var/lib/dawarich/secrets/db-password";
          description = ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };
      };

      # TODO? only used for password reset and confirmation emails
      smtp = {
        createLocally = lib.mkOption {
          description = "Configure local Postfix SMTP server for Mastodon.";
          type = lib.types.bool;
          default = false;
        };

        authenticate = lib.mkOption {
          description = "Authenticate with the SMTP server using username and password.";
          type = lib.types.bool;
          default = false;
        };

        host = lib.mkOption {
          description = "SMTP host used when sending emails to users.";
          type = lib.types.str;
          default = "127.0.0.1";
        };

        port = lib.mkOption {
          description = "SMTP port used when sending emails to users.";
          type = lib.types.port;
          default = 25;
        };

        fromAddress = lib.mkOption {
          description = ''"From" address used when sending Emails to users.'';
          type = lib.types.str;
        };

        user = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "mastodon@example.com";
          description = "SMTP login name.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/var/lib/mastodon/secrets/smtp-password";
          description = ''
            Path to file containing the SMTP password.
          '';
        };
      };

      package = lib.mkPackageOption pkgs "dawarich" { };

      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = ''
          Extra environment variables to pass to all dawarich services.
        '';
      };

      extraEnvFiles = lib.mkOption {
        type = with lib.types; listOf path;
        default = [ ];
        description = ''
          Extra environment files to pass to all Dawarich services. Useful for passing down environmental secrets.
        '';
        example = [ "/etc/dawarich/secret.env" ];
      };

      automaticMigrations = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Perform database migrations automatically.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion =
              !redisActuallyCreateLocally -> (cfg.redis.host != "127.0.0.1" && cfg.redis.port != null);
            message = ''
              `services.dawarich.redis.host` and `services.dawarich.redis.port` need to be set if
                `services.dawarich.redis.createLocally` is not enabled.
            '';
          }
          {
            assertion =
              redisActuallyCreateLocally
              -> (!cfg.redis.enableUnixSocket || (cfg.redis.host == null && cfg.redis.port == null));
            message = ''
              `services.dawarich.redis.enableUnixSocket` needs to be disabled if
                `services.dawarich.redis.host` and `services.dawarich.redis.port` is used.
            '';
          }
          {
            assertion =
              redisActuallyCreateLocally -> (!cfg.redis.enableUnixSocket || cfg.redis.passwordFile == null);
            message = ''
              <option>services.dawarich.redis.enableUnixSocket</option> needs to be disabled if
                <option>services.dawarich.redis.passwordFile</option> is used.
            '';
          }
          {
            assertion =
              databaseActuallyCreateLocally
              -> (cfg.user == cfg.database.user && cfg.database.user == cfg.database.name);
            message = ''
              For local automatic database provisioning (services.dawarich.database.createLocally == true) with peer
                authentication (services.dawarich.database.host == "/run/postgresql") to work services.dawarich.user
                and services.dawarich.database.user must be identical.
            '';
          }
          {
            assertion = !databaseActuallyCreateLocally -> (cfg.database.host != "/run/postgresql");
            message = ''
              <option>services.dawarich.database.host</option> needs to be set if
                <option>services.dawarich.database.createLocally</option> is not enabled.
            '';
          }
          {
            assertion = cfg.smtp.authenticate -> (cfg.smtp.user != null);
            message = ''
              <option>services.dawarich.smtp.user</option> needs to be set if
                <option>services.dawarich.smtp.authenticate</option> is enabled.
            '';
          }
          {
            assertion = cfg.smtp.authenticate -> (cfg.smtp.passwordFile != null);
            message = ''
              <option>services.dawarich.smtp.passwordFile</option> needs to be set if
                <option>services.dawarich.smtp.authenticate</option> is enabled.
            '';
          }
        ];

        systemd.targets.dawarich = {
          description = "Target for all Dawarich services";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
        };

        systemd.services.dawarich-init-db = lib.mkIf cfg.automaticMigrations {
          script = ''
            # Run primary database migrations first (needed before other migrations)
            echo "Running primary database migrations..."
            rails db:migrate

            # Run data migrations
            echo "Running DATA migrations..."
            rake data:migrate

            echo "Running seeds..."
            rails db:seed
          '';
          path = [ cfg.package ];
          environment = env;
          serviceConfig = {
            Type = "oneshot";
            EnvironmentFile = cfg.extraEnvFiles;
            WorkingDirectory = cfg.package;
            # System Call Filtering
            SystemCallFilter = [
              ("~" + lib.concatStringsSep " " (systemCallsList ++ [ "@resources" ]))
              "@chown"
              "pipe"
              "pipe2"
            ];
          } // cfgService;
          # both postgres and redis are needed for the migrations to work
          after =
            [
              "network.target"
            ]
            ++ lib.optional databaseActuallyCreateLocally "postgresql.target"
            ++ lib.optional redisActuallyCreateLocally "redis-dawarich.service";
          requires =
            lib.optional databaseActuallyCreateLocally "postgresql.target"
            ++ lib.optional redisActuallyCreateLocally "redis-dawarich.service";
        };

        systemd.services.dawarich-web = {
          after = [
            "network.target"
          ] ++ commonUnits;
          requires = commonUnits;
          wantedBy = [ "dawarich.target" ];
          description = "Dawarich web";
          environment =
            env
            // (
              # TODO does this work?
              if cfg.enableUnixSocket then
                { SOCKET = "/run/dawarich-web/web.socket"; }
              else
                { PORT = toString cfg.webPort; }
            );
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/rails server";
            Restart = "always";
            RestartSec = 20;
            EnvironmentFile = cfg.extraEnvFiles;
            WorkingDirectory = cfg.package;
            # Runtime directory and mode
            RuntimeDirectory = "dawarich-web";
            RuntimeDirectoryMode = "0750";
            # System Call Filtering
            SystemCallFilter = [
              ("~" + lib.concatStringsSep " " systemCallsList)
              "@chown"
              "pipe"
              "pipe2"
            ];
          } // cfgService;
        };

        services.nginx = lib.mkIf cfg.configureNginx {
          enable = true;
          virtualHosts."${cfg.localDomain}" = {
            root = "${cfg.package}/public/";

            locations."/" = {
              tryFiles = "$uri @proxy";
            };

            locations."@proxy" = {
              proxyPass = (
                if cfg.enableUnixSocket then
                  "http://unix:/run/dawarich-web/web.socket"
                else
                  "http://127.0.0.1:${toString cfg.webPort}"
              );
            };
          };
        };

        services.redis.servers.dawarich = lib.mkIf redisActuallyCreateLocally (
          lib.mkMerge [
            {
              enable = true;
            }
            (lib.mkIf (!cfg.redis.enableUnixSocket) {
              port = cfg.redis.port;
            })
          ]
        );

        services.postgresql = lib.mkIf databaseActuallyCreateLocally {
          enable = true;
          extensions = ps: with ps; [ postgis ];
          ensureUsers = [
            {
              name = cfg.database.name;
              ensureDBOwnership = true;
            }
          ];
          ensureDatabases = [ cfg.database.name ];
        };

        systemd.services.postgresql-setup.serviceConfig.ExecStartPost =
          let
            sqlFile = pkgs.writeText "dawarich-postgres-setup.sql" ''
              CREATE EXTENSION IF NOT EXISTS "pg_catalog.plpgsql";
              CREATE EXTENSION IF NOT EXISTS postgis;
            '';
          in
          lib.mkIf databaseActuallyCreateLocally [
            ''
              ${lib.getExe' config.services.postgresql.package "psql"} -d "${cfg.database.name}" -f "${sqlFile}"
            ''
          ];

        users.users = lib.mkMerge [
          (lib.mkIf (cfg.user == "dawarich") {
            dawarich = {
              isSystemUser = true;
              home = cfg.package;
              inherit (cfg) group;
            };
          })
          # TODO don't think this is needed
          # (lib.attrsets.setAttrByPath [ cfg.user "packages" ] [ cfg.package ])
          (lib.mkIf (cfg.redis.createLocally && cfg.redis.enableUnixSocket) {
            ${config.services.dawarich.user}.extraGroups = [ "redis-dawarich" ];
          })
        ];

        # TODO: use SupplementaryGroups instead
        users.groups.${cfg.group}.members = lib.optional cfg.configureNginx config.services.nginx.user;
      }
      {
        systemd.services = lib.mkMerge [
          sidekiqUnits
        ];
      }
    ]
  );

  meta.maintainers = with lib.maintainers; [
    diogotcorreia
  ];

}
