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

  dataDir = "/var/lib/dawarich";

  # We only want to create a Redis and PostgreSQL databases if we're actually going to connect to it local.
  redisActuallyCreateLocally =
    cfg.redis.createLocally && (cfg.redis.host == "127.0.0.1" || cfg.redis.enableUnixSocket);
  databaseActuallyCreateLocally =
    cfg.database.createLocally && cfg.database.host == "/run/postgresql";

  env = {
    RAILS_ENV = "production";
    NODE_ENV = "production";
    BUNDLE_USER_HOME = "/tmp/bundle"; # will use private tmp inside systemd unit

    SELF_HOSTED = "true";
    STORE_GEODATA = "true";
    APPLICATION_PROTOCOL = "http";
    TIME_ZONE = config.time.timeZone; # otherwise upstream forces it to Europe/London
    DOMAIN = cfg.localDomain;
    APPLICATION_HOSTS = "127.0.0.1,::1,${cfg.localDomain}";

    BOOTSNAP_CACHE_DIR = "/var/cache/dawarich/precompile";
    LD_PRELOAD = "${pkgs.jemalloc}/lib/libjemalloc.so";

    DATABASE_USER = cfg.database.user;
    DATABASE_HOST = cfg.database.host;
    DATABASE_NAME = cfg.database.name;

    SMTP_SERVER = cfg.smtp.host;
    SMTP_PORT = toString cfg.smtp.port;
    SMTP_FROM = cfg.smtp.fromAddress;
    SMTP_USERNAME = cfg.smtp.user;
    PORT = toString cfg.webPort;
  }
  // lib.optionalAttrs (!cfg.redis.enableUnixSocket) {
    # Does not support passwords, but upstream does not provide an adequate env variable
    # Perhaps patch or make a PR upstream in the future
    REDIS_URL = "redis://${cfg.redis.host}:${cfg.redis.port}";
  }
  // lib.optionalAttrs (cfg.redis.createLocally && cfg.redis.enableUnixSocket) {
    REDIS_URL = "unix://${config.services.redis.servers.dawarich.unixSocket}";
  }
  // lib.optionalAttrs (cfg.database.host != "/run/postgresql" && cfg.database.port != null) {
    DATABASE_PORT = toString cfg.database.port;
  }
  // cfg.extraConfig;

  systemCallFilter =
    let
      allowedSystemCalls = [
        "@cpu-emulation"
        "@debug"
        "@keyring"
        "@ipc"
        "@mount"
        "@obsolete"
        "@privileged"
        "@setuid"
      ];
    in
    [
      ("~" + lib.concatStringsSep " " allowedSystemCalls)
      "@chown"
      "pipe"
      "pipe2"
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
    SystemCallFilter = systemCallFilter;
  };

  # Units that all Dawarich units After= and Requires= on
  commonUnits =
    lib.optional redisActuallyCreateLocally "redis-dawarich.service"
    ++ lib.optional databaseActuallyCreateLocally "postgresql.target"
    ++ lib.optional cfg.automaticMigrations "dawarich-init-db.service";

  defaultSecretKeyBaseFile = "${dataDir}/secrets/secret-key-base";
  needsGenCredentialsUnit = cfg.secretKeyBaseFile == null;
  credentials = {
    SECRET_KEY_BASE = lib.defaultTo defaultSecretKeyBaseFile cfg.secretKeyBaseFile;
  }
  // lib.optionalAttrs (cfg.database.passwordFile != null) {
    DATABASE_PASSWORD = cfg.database.passwordFile;
  }
  // lib.optionalAttrs (cfg.smtp.passwordFile != null) {
    SMTP_PASSWORD = cfg.smtp.passwordFile;
  };
  loadCredentialsIntoEnv = lib.concatMapAttrsStringSep "\n" (
    name: _: ''export ${name}="$(systemd-creds cat ${name})"''
  ) credentials;
  loadCredentials = lib.mapAttrsToList (name: path: "${name}:${path}") credentials;

  dawarichRails = pkgs.writeShellApplication {
    name = "dawarich-rails";

    text =
      let
        sourceExtraEnv = lib.concatMapStrings (p: "source ${p}\n") cfg.extraEnvFiles;
        command = pkgs.writeShellScript "dawarich-rails-unwrapped" ''
          ${sourceExtraEnv}
          ${loadCredentialsIntoEnv}
          export RAILS_ROOT="${cfg.package}"
          exec ${lib.getExe' cfg.package "rails"} "$@"
        '';
        env' = lib.filterAttrs (_: value: value != null) env;
      in
      ''
        exec ${lib.getExe' config.systemd.package "systemd-run"} \
          ${
            lib.escapeShellArgs (map (credential: "--property=LoadCredential=${credential}") loadCredentials)
          } \
          ${
            lib.escapeShellArgs (lib.mapAttrsToList (name: value: "--setenv=${name}=${toString value}") env')
          } \
          --uid=${lib.escapeShellArg cfg.user} \
          --working-directory=${lib.escapeShellArg cfg.package} \
          --property=PrivateTmp=yes \
          --pty \
          --wait \
          --collect \
          --service-type=exec \
          --quiet \
          -- \
          ${command} "$@"
      '';
  };
  dawarichConsole = pkgs.writeShellScriptBin "dawarich-console" ''
    exec ${lib.getExe dawarichRails} console "$@"
  '';

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
        ]
        ++ lib.optional needsGenCredentialsUnit "dawarich-init-credentials.service"
        ++ commonUnits;
        requires = lib.optional needsGenCredentialsUnit "dawarich-init-credentials.service" ++ commonUnits;
        description = "Dawarich sidekiq${jobClassLabel}";
        wantedBy = [ "dawarich.target" ];
        environment = env // {
          RAILS_MAX_THREADS = threads;
        };
        script = ''
          ${loadCredentialsIntoEnv}

          ${lib.getExe' cfg.package "sidekiq"} ${jobClassArgs} -c ${threads} -r ${cfg.package}
        '';
        serviceConfig = {
          Restart = "always";
          RestartSec = 20;
          LoadCredential = loadCredentials;
          EnvironmentFile = cfg.extraEnvFiles;
          LimitNOFILE = "1024000";
        }
        // cfgService;
      }
    )
  ) cfg.sidekiqProcesses;

in
{

  options = {
    services.dawarich = {
      enable = lib.mkEnableOption "Dawarich, a self-hostable alternative to Google Location History";

      configureNginx = lib.mkOption {
        description = ''
          Configure nginx as a reverse proxy for dawarich.
          Alternatively you can configure a reverse-proxy of your choice to serve these paths:

          `/ -> ''${pkgs.dawarich}/public`

          `/ -> 127.0.0.1:{{ webPort }} `(If there was no file in the directory above.)

          Make sure that websockets are forwarded properly. You might want to set up caching
          of some requests. Take a look at dawarich's provided reverse proxy configurations at
          `https://dawarich.app/docs/tutorials/reverse-proxy`.
        '';
        type = lib.types.bool;
        default = true;
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

      localDomain = lib.mkOption {
        description = "The domain serving your Dawarich instance.";
        example = "dawarich.example.org";
        type = lib.types.str;
      };

      secretKeyBaseFile = lib.mkOption {
        description = ''
          Path to file containing the secret key base.
          A new secret key base can be generated by running:

          `nix build -f '<nixpkgs>' dawarich; cd result; bin/bundle exec rails secret`

          This file is loaded using systemd credentials, and therefore does not need to be
          owned by the dawarich user.

          If this option is null, it will be created at ${defaultSecretKeyBaseFile}
          with a new secret key base.
        '';
        default = null;
        type = lib.types.nullOr lib.types.str;
      };

      redis = {
        createLocally = lib.mkEnableOption "configuring a local Redis server for Dawarich" // {
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

        enableUnixSocket = lib.mkEnableOption "using the Unix socket to connect to Redis" // {
          default = true;
        };
      };

      database = {
        createLocally =
          lib.mkEnableOption "configuring a local PostgreSQL database server for Dawarich"
          // {
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
          example = "/run/keys/dawarich-db-password";
          description = ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };
      };

      smtp = {
        host = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "SMTP host used when sending emails to users.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 25;
          description = "SMTP port used when sending emails to users.";
        };

        fromAddress = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "dawarich@example.com";
          description = ''"From" address used when sending emails to users.'';
        };

        user = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "dawarich@example.com";
          description = "SMTP login name.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/dawarich-smtp-password";
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
          Extra environment files to pass to all Dawarich services. Useful for passing down environment secrets.
        '';
        example = [ "/etc/dawarich/secret.env" ];
      };

      automaticMigrations = lib.mkEnableOption "performing database migrations automatically" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = !redisActuallyCreateLocally -> (cfg.redis.host != null && cfg.redis.port != null);
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
        ];

        environment.systemPackages = [
          dawarichConsole
          dawarichRails
        ];

        systemd.targets.dawarich = {
          description = "Target for all Dawarich services";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
        };

        systemd.services.dawarich-init-credentials = lib.mkIf needsGenCredentialsUnit {
          script = ''
            umask 077
          ''
          + lib.optionalString (cfg.secretKeyBaseFile == null) ''
            if ! test -f ${defaultSecretKeyBaseFile}; then
              mkdir -p $(dirname ${defaultSecretKeyBaseFile})
              bin/bundle exec rails secret > ${defaultSecretKeyBaseFile}
            fi
          '';

          environment = env;
          serviceConfig = {
            Type = "oneshot";
            SyslogIdentifier = "dawarich-init-dirs";
            # System Call Filtering
            SystemCallFilter = [ "~@resources" ] ++ systemCallFilter;
          }
          // cfgService;

          after = [ "network.target" ];
        };

        systemd.services.dawarich-init-db = lib.mkIf cfg.automaticMigrations {
          script = ''
            ${loadCredentialsIntoEnv}

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
            LoadCredential = loadCredentials;
            EnvironmentFile = cfg.extraEnvFiles;
            WorkingDirectory = cfg.package;
            # System Call Filtering
            SystemCallFilter = [ "~@resources" ] ++ systemCallFilter;
          }
          // cfgService;
          # both postgres and redis are needed for the migrations to work
          after = [
            "network.target"
          ]
          ++ lib.optional needsGenCredentialsUnit "dawarich-init-credentials.service"
          ++ lib.optional databaseActuallyCreateLocally "postgresql.target"
          ++ lib.optional redisActuallyCreateLocally "redis-dawarich.service";
          requires =
            lib.optional needsGenCredentialsUnit "dawarich-init-credentials.service"
            ++ lib.optional databaseActuallyCreateLocally "postgresql.target"
            ++ lib.optional redisActuallyCreateLocally "redis-dawarich.service";
        };

        systemd.services.dawarich-web = {
          after = [
            "network.target"
          ]
          ++ lib.optional needsGenCredentialsUnit "dawarich-init-credentials.service"
          ++ commonUnits;
          requires = lib.optional needsGenCredentialsUnit "dawarich-init-credentials.service" ++ commonUnits;
          wantedBy = [ "dawarich.target" ];
          description = "Dawarich web";
          environment = env;
          script = ''
            ${loadCredentialsIntoEnv}

            ${lib.getExe' cfg.package "rails"} server
          '';
          serviceConfig = {
            Restart = "always";
            RestartSec = 20;
            LoadCredential = loadCredentials;
            EnvironmentFile = cfg.extraEnvFiles;
            WorkingDirectory = cfg.package;
            # Runtime directory and mode
            RuntimeDirectory = "dawarich-web";
            RuntimeDirectoryMode = "0750";
          }
          // cfgService;
        };

        systemd.tmpfiles.settings."dawarich"."${dataDir}/imports/watched".d = {
          group = "dawarich";
          mode = "700";
          user = "dawarich";
        };

        services.nginx = lib.mkIf cfg.configureNginx {
          enable = true;
          virtualHosts."${cfg.localDomain}" = {
            root = "${cfg.package}/public/";

            locations."/" = {
              tryFiles = "$uri @proxy";
            };

            locations."@proxy" = {
              proxyPass = "http://127.0.0.1:${toString cfg.webPort}";
              recommendedProxySettings = true;
              proxyWebsockets = true;
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
              inherit (cfg.database) name;
              ensureDBOwnership = true;
            }
          ];
          ensureDatabases = [ cfg.database.name ];
        };

        systemd.services.postgresql-setup.serviceConfig.ExecStartPost =
          let
            # https://github.com/Freika/dawarich/blob/0.30.6/db/schema.rb#L15-L16
            extensions = [
              "plpgsql"
              "postgis"
            ];
            sqlFile = pkgs.writeText "dawarich-postgres-setup.sql" ''
              ${lib.concatMapStringsSep "\n" (ext: "CREATE EXTENSION IF NOT EXISTS \"${ext}\";") extensions}
              ${lib.concatMapStringsSep "\n" (ext: "ALTER EXTENSION \"${ext}\" UPDATE;") extensions}
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
          (lib.mkIf (cfg.redis.createLocally && cfg.redis.enableUnixSocket) {
            ${config.services.dawarich.user}.extraGroups = [ "redis-dawarich" ];
          })
        ];
        users.groups = lib.mkIf (cfg.group == "dawarich") { ${cfg.group} = { }; };
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
