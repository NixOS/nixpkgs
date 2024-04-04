{ lib, pkgs, config, options, ... }:

let
  cfg = config.services.mastodon;
  opt = options.services.mastodon;

  # We only want to create a Redis and PostgreSQL databases if we're actually going to connect to it local.
  redisActuallyCreateLocally = cfg.redis.createLocally && (cfg.redis.host == "127.0.0.1" || cfg.redis.enableUnixSocket);
  databaseActuallyCreateLocally = cfg.database.createLocally && cfg.database.host == "/run/postgresql";

  env = {
    RAILS_ENV = "production";
    NODE_ENV = "production";

    LD_PRELOAD = "${pkgs.jemalloc}/lib/libjemalloc.so";

    # mastodon-web concurrency.
    WEB_CONCURRENCY = toString cfg.webProcesses;
    MAX_THREADS = toString cfg.webThreads;

    DB_USER = cfg.database.user;

    REDIS_HOST = cfg.redis.host;
    REDIS_PORT = toString(cfg.redis.port);
    DB_HOST = cfg.database.host;
    DB_NAME = cfg.database.name;
    LOCAL_DOMAIN = cfg.localDomain;
    SMTP_SERVER = cfg.smtp.host;
    SMTP_PORT = toString(cfg.smtp.port);
    SMTP_FROM_ADDRESS = cfg.smtp.fromAddress;
    PAPERCLIP_ROOT_PATH = "/var/lib/mastodon/public-system";
    PAPERCLIP_ROOT_URL = "/system";
    ES_ENABLED = if (cfg.elasticsearch.host != null) then "true" else "false";

    TRUSTED_PROXY_IP = cfg.trustedProxy;
  }
  // lib.optionalAttrs (cfg.redis.createLocally && cfg.redis.enableUnixSocket) { REDIS_URL = "unix://${config.services.redis.servers.mastodon.unixSocket}"; }
  // lib.optionalAttrs (cfg.database.host != "/run/postgresql" && cfg.database.port != null) { DB_PORT = toString cfg.database.port; }
  // lib.optionalAttrs cfg.smtp.authenticate { SMTP_LOGIN  = cfg.smtp.user; }
  // lib.optionalAttrs (cfg.elasticsearch.host != null) { ES_HOST = cfg.elasticsearch.host; }
  // lib.optionalAttrs (cfg.elasticsearch.host != null) { ES_PORT = toString(cfg.elasticsearch.port); }
  // lib.optionalAttrs (cfg.elasticsearch.host != null) { ES_PRESET = cfg.elasticsearch.preset; }
  // lib.optionalAttrs (cfg.elasticsearch.user != null) { ES_USER = cfg.elasticsearch.user; }
  // cfg.extraConfig;

  systemCallsList = [ "@cpu-emulation" "@debug" "@keyring" "@ipc" "@mount" "@obsolete" "@privileged" "@setuid" ];

  cfgService = {
    # User and group
    User = cfg.user;
    Group = cfg.group;
    # Working directory
    WorkingDirectory = cfg.package;
    # State directory and mode
    StateDirectory = "mastodon";
    StateDirectoryMode = "0750";
    # Logs directory and mode
    LogsDirectory = "mastodon";
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
    RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
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

  envFile = pkgs.writeText "mastodon.env" (lib.concatMapStrings (s: s + "\n") (
    (lib.concatLists (lib.mapAttrsToList (name: value:
      lib.optional (value != null) ''${name}="${toString value}"''
    ) env))));

  mastodonTootctl = let
    sourceExtraEnv = lib.concatMapStrings (p: "source ${p}\n") cfg.extraEnvFiles;
  in pkgs.writeShellScriptBin "mastodon-tootctl" ''
    set -a
    export RAILS_ROOT="${cfg.package}"
    source "${envFile}"
    source /var/lib/mastodon/.secrets_env
    ${sourceExtraEnv}

    sudo=exec
    if [[ "$USER" != ${cfg.user} ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${cfg.user} --preserve-env'
    fi
    $sudo ${cfg.package}/bin/tootctl "$@"
  '';

  sidekiqUnits = lib.attrsets.mapAttrs' (name: processCfg:
    lib.nameValuePair "mastodon-sidekiq-${name}" (let
      jobClassArgs = toString (builtins.map (c: "-q ${c}") processCfg.jobClasses);
      jobClassLabel = toString ([""] ++ processCfg.jobClasses);
      threads = toString (if processCfg.threads == null then cfg.sidekiqThreads else processCfg.threads);
    in {
      after = [ "network.target" "mastodon-init-dirs.service" ]
        ++ lib.optional redisActuallyCreateLocally "redis-mastodon.service"
        ++ lib.optional databaseActuallyCreateLocally "postgresql.service"
        ++ lib.optional cfg.automaticMigrations "mastodon-init-db.service";
      requires = [ "mastodon-init-dirs.service" ]
        ++ lib.optional redisActuallyCreateLocally "redis-mastodon.service"
        ++ lib.optional databaseActuallyCreateLocally "postgresql.service"
        ++ lib.optional cfg.automaticMigrations "mastodon-init-db.service";
      description = "Mastodon sidekiq${jobClassLabel}";
      wantedBy = [ "mastodon.target" ];
      environment = env // {
        PORT = toString(cfg.sidekiqPort);
        DB_POOL = threads;
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/sidekiq ${jobClassArgs} -c ${threads} -r ${cfg.package}";
        Restart = "always";
        RestartSec = 20;
        EnvironmentFile = [ "/var/lib/mastodon/.secrets_env" ] ++ cfg.extraEnvFiles;
        WorkingDirectory = cfg.package;
        LimitNOFILE = "1024000";
        # System Call Filtering
        SystemCallFilter = [ ("~" + lib.concatStringsSep " " systemCallsList) "@chown" "pipe" "pipe2" ];
      } // cfgService;
      path = with pkgs; [ ffmpeg-headless file imagemagick ];
    })
  ) cfg.sidekiqProcesses;

  streamingUnits = builtins.listToAttrs
      (map (i: {
        name = "mastodon-streaming-${toString i}";
        value = {
          after = [ "network.target" "mastodon-init-dirs.service" ]
            ++ lib.optional redisActuallyCreateLocally "redis-mastodon.service"
            ++ lib.optional databaseActuallyCreateLocally "postgresql.service"
            ++ lib.optional cfg.automaticMigrations "mastodon-init-db.service";
          requires = [ "mastodon-init-dirs.service" ]
            ++ lib.optional redisActuallyCreateLocally "redis-mastodon.service"
            ++ lib.optional databaseActuallyCreateLocally "postgresql.service"
            ++ lib.optional cfg.automaticMigrations "mastodon-init-db.service";
          wantedBy = [ "mastodon.target" "mastodon-streaming.target" ];
          description = "Mastodon streaming ${toString i}";
          environment = env // { SOCKET = "/run/mastodon-streaming/streaming-${toString i}.socket"; };
          serviceConfig = {
            ExecStart = "${cfg.package}/run-streaming.sh";
            Restart = "always";
            RestartSec = 20;
            EnvironmentFile = [ "/var/lib/mastodon/.secrets_env" ] ++ cfg.extraEnvFiles;
            WorkingDirectory = cfg.package;
            # Runtime directory and mode
            RuntimeDirectory = "mastodon-streaming";
            RuntimeDirectoryMode = "0750";
            # System Call Filtering
            SystemCallFilter = [ ("~" + lib.concatStringsSep " " (systemCallsList ++ [ "@memlock" "@resources" ])) "pipe" "pipe2" ];
          } // cfgService;
        };
      })
      (lib.range 1 cfg.streamingProcesses));

in {

  imports = [
    (lib.mkRemovedOptionModule
      [ "services" "mastodon" "streamingPort" ]
      "Mastodon currently doesn't support streaming via TCP ports. Please open a PR if you need this."
    )
  ];

  options = {
    services.mastodon = {
      enable = lib.mkEnableOption (lib.mdDoc "Mastodon, a federated social network server");

      configureNginx = lib.mkOption {
        description = lib.mdDoc ''
          Configure nginx as a reverse proxy for mastodon.
          Note that this makes some assumptions on your setup, and sets settings that will
          affect other virtualHosts running on your nginx instance, if any.
          Alternatively you can configure a reverse-proxy of your choice to serve these paths:

          `/ -> $(nix-instantiate --eval '<nixpkgs>' -A mastodon.outPath)/public`

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
        description = lib.mdDoc ''
          User under which mastodon runs. If it is set to "mastodon",
          that user will be created, otherwise it should be set to the
          name of a user created elsewhere.
          In both cases, the `mastodon` package will be added to the user's package set
          and a tootctl wrapper to system packages that switches to the configured account
          and load the right environment.
        '';
        type = lib.types.str;
        default = "mastodon";
      };

      group = lib.mkOption {
        description = lib.mdDoc ''
          Group under which mastodon runs.
        '';
        type = lib.types.str;
        default = "mastodon";
      };

      streamingProcesses = lib.mkOption {
        description = lib.mdDoc ''
          Number of processes used by the mastodon-streaming service.
          Please define this explicitly, recommended is the amount of your CPU cores minus one.
        '';
        type = lib.types.ints.positive;
        example = 3;
      };

      webPort = lib.mkOption {
        description = lib.mdDoc "TCP port used by the mastodon-web service.";
        type = lib.types.port;
        default = 55001;
      };
      webProcesses = lib.mkOption {
        description = lib.mdDoc "Processes used by the mastodon-web service.";
        type = lib.types.int;
        default = 2;
      };
      webThreads = lib.mkOption {
        description = lib.mdDoc "Threads per process used by the mastodon-web service.";
        type = lib.types.int;
        default = 5;
      };

      sidekiqPort = lib.mkOption {
        description = lib.mdDoc "TCP port used by the mastodon-sidekiq service.";
        type = lib.types.port;
        default = 55002;
      };

      sidekiqThreads = lib.mkOption {
        description = lib.mdDoc "Worker threads used by the mastodon-sidekiq-all service. If `sidekiqProcesses` is configured and any processes specify null `threads`, this value is used.";
        type = lib.types.int;
        default = 25;
      };

      sidekiqProcesses = lib.mkOption {
        description = lib.mdDoc "How many Sidekiq processes should be used to handle background jobs, and which job classes they handle. *Read the [upstream documentation](https://docs.joinmastodon.org/admin/scaling/#sidekiq) before configuring this!*";
        type = with lib.types; attrsOf (submodule {
          options = {
            jobClasses = lib.mkOption {
              type = listOf (enum [ "default" "push" "pull" "mailers" "scheduler" "ingress" ]);
              description = lib.mdDoc "If not empty, which job classes should be executed by this process. *Only one process should handle the 'scheduler' class. If left empty, this process will handle the 'scheduler' class.*";
            };
            threads = lib.mkOption {
              type = nullOr int;
              description = lib.mdDoc "Number of threads this process should use for executing jobs. If null, the configured `sidekiqThreads` are used.";
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
          ingress = {
            jobClasses = [ "ingress" ];
            threads = 5;
          };
          default = {
            jobClasses = [ "default" ];
            threads = 10;
          };
          push-pull = {
            jobClasses = [ "push" "pull" ];
            threads = 5;
          };
        };
      };

      vapidPublicKeyFile = lib.mkOption {
        description = lib.mdDoc ''
          Path to file containing the public key used for Web Push
          Voluntary Application Server Identification.  A new keypair can
          be generated by running:

          `nix build -f '<nixpkgs>' mastodon; cd result; bin/rake webpush:generate_keys`

          If {option}`mastodon.vapidPrivateKeyFile`does not
          exist, it and this file will be created with a new keypair.
        '';
        default = "/var/lib/mastodon/secrets/vapid-public-key";
        type = lib.types.str;
      };

      localDomain = lib.mkOption {
        description = lib.mdDoc "The domain serving your Mastodon instance.";
        example = "social.example.org";
        type = lib.types.str;
      };

      secretKeyBaseFile = lib.mkOption {
        description = lib.mdDoc ''
          Path to file containing the secret key base.
          A new secret key base can be generated by running:

          `nix build -f '<nixpkgs>' mastodon; cd result; bin/rake secret`

          If this file does not exist, it will be created with a new secret key base.
        '';
        default = "/var/lib/mastodon/secrets/secret-key-base";
        type = lib.types.str;
      };

      otpSecretFile = lib.mkOption {
        description = lib.mdDoc ''
          Path to file containing the OTP secret.
          A new OTP secret can be generated by running:

          `nix build -f '<nixpkgs>' mastodon; cd result; bin/rake secret`

          If this file does not exist, it will be created with a new OTP secret.
        '';
        default = "/var/lib/mastodon/secrets/otp-secret";
        type = lib.types.str;
      };

      vapidPrivateKeyFile = lib.mkOption {
        description = lib.mdDoc ''
          Path to file containing the private key used for Web Push
          Voluntary Application Server Identification.  A new keypair can
          be generated by running:

          `nix build -f '<nixpkgs>' mastodon; cd result; bin/rake webpush:generate_keys`

          If this file does not exist, it will be created with a new
          private key.
        '';
        default = "/var/lib/mastodon/secrets/vapid-private-key";
        type = lib.types.str;
      };

      trustedProxy = lib.mkOption {
        description = lib.mdDoc ''
          You need to set it to the IP from which your reverse proxy sends requests to Mastodon's web process,
          otherwise Mastodon will record the reverse proxy's own IP as the IP of all requests, which would be
          bad because IP addresses are used for important rate limits and security functions.
        '';
        type = lib.types.str;
        default = "127.0.0.1";
      };

      enableUnixSocket = lib.mkOption {
        description = lib.mdDoc ''
          Instead of binding to an IP address like 127.0.0.1, you may bind to a Unix socket. This variable
          is process-specific, e.g. you need different values for every process, and it works for both web (Puma)
          processes and streaming API (Node.js) processes.
        '';
        type = lib.types.bool;
        default = true;
      };

      redis = {
        createLocally = lib.mkOption {
          description = lib.mdDoc "Configure local Redis server for Mastodon.";
          type = lib.types.bool;
          default = true;
        };

        host = lib.mkOption {
          description = lib.mdDoc "Redis host.";
          type = lib.types.str;
          default = "127.0.0.1";
        };

        port = lib.mkOption {
          description = lib.mdDoc "Redis port.";
          type = lib.types.port;
          default = 31637;
        };

        passwordFile = lib.mkOption {
          description = lib.mdDoc "A file containing the password for Redis database.";
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/mastodon-redis-password";
        };

        enableUnixSocket = lib.mkOption {
          description = lib.mdDoc "Use Unix socket";
          type = lib.types.bool;
          default = true;
        };
      };

      database = {
        createLocally = lib.mkOption {
          description = lib.mdDoc "Configure local PostgreSQL database server for Mastodon.";
          type = lib.types.bool;
          default = true;
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "/run/postgresql";
          example = "192.168.23.42";
          description = lib.mdDoc "Database host address or unix socket.";
        };

        port = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = if cfg.database.createLocally then null else 5432;
          defaultText = lib.literalExpression ''
            if config.${opt.database.createLocally}
            then null
            else 5432
          '';
          description = lib.mdDoc "Database host port.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "mastodon";
          description = lib.mdDoc "Database name.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "mastodon";
          description = lib.mdDoc "Database user.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/var/lib/mastodon/secrets/db-password";
          description = lib.mdDoc ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };
      };

      smtp = {
        createLocally = lib.mkOption {
          description = lib.mdDoc "Configure local Postfix SMTP server for Mastodon.";
          type = lib.types.bool;
          default = true;
        };

        authenticate = lib.mkOption {
          description = lib.mdDoc "Authenticate with the SMTP server using username and password.";
          type = lib.types.bool;
          default = false;
        };

        host = lib.mkOption {
          description = lib.mdDoc "SMTP host used when sending emails to users.";
          type = lib.types.str;
          default = "127.0.0.1";
        };

        port = lib.mkOption {
          description = lib.mdDoc "SMTP port used when sending emails to users.";
          type = lib.types.port;
          default = 25;
        };

        fromAddress = lib.mkOption {
          description = lib.mdDoc ''"From" address used when sending Emails to users.'';
          type = lib.types.str;
        };

        user = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "mastodon@example.com";
          description = lib.mdDoc "SMTP login name.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/var/lib/mastodon/secrets/smtp-password";
          description = lib.mdDoc ''
            Path to file containing the SMTP password.
          '';
        };
      };

      elasticsearch = {
        host = lib.mkOption {
          description = lib.mdDoc ''
            Elasticsearch host.
            If it is not null, Elasticsearch full text search will be enabled.
          '';
          type = lib.types.nullOr lib.types.str;
          default = null;
        };

        port = lib.mkOption {
          description = lib.mdDoc "Elasticsearch port.";
          type = lib.types.port;
          default = 9200;
        };

        preset = lib.mkOption {
          description = lib.mdDoc ''
            It controls the ElasticSearch indices configuration (number of shards and replica).
          '';
          type = lib.types.enum [ "single_node_cluster" "small_cluster" "large_cluster" ];
          default = "single_node_cluster";
          example = "large_cluster";
        };

        user = lib.mkOption {
          description = lib.mdDoc "Used for optionally authenticating with Elasticsearch.";
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "elasticsearch-mastodon";
        };

        passwordFile = lib.mkOption {
          description = lib.mdDoc ''
            Path to file containing password for optionally authenticating with Elasticsearch.
          '';
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/var/lib/mastodon/secrets/elasticsearch-password";
        };
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.mastodon;
        defaultText = lib.literalExpression "pkgs.mastodon";
        description = lib.mdDoc "Mastodon package to use.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = lib.mdDoc ''
          Extra environment variables to pass to all mastodon services.
        '';
      };

      extraEnvFiles = lib.mkOption {
        type = with lib.types; listOf path;
        default = [];
        description = lib.mdDoc ''
          Extra environment files to pass to all mastodon services. Useful for passing down environmental secrets.
        '';
        example = [ "/etc/mastodon/s3config.env" ];
      };

      automaticMigrations = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc ''
          Do automatic database migrations.
        '';
      };

      mediaAutoRemove = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          example = false;
          description = lib.mdDoc ''
            Automatically remove remote media attachments and preview cards older than the configured amount of days.

            Recommended in https://docs.joinmastodon.org/admin/setup/.
          '';
        };

        startAt = lib.mkOption {
          type = lib.types.str;
          default = "daily";
          example = "hourly";
          description = lib.mdDoc ''
            How often to remove remote media.

            The format is described in {manpage}`systemd.time(7)`.
          '';
        };

        olderThanDays = lib.mkOption {
          type = lib.types.int;
          default = 30;
          example = 14;
          description = lib.mdDoc ''
            How old remote media needs to be in order to be removed.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [{
    assertions = [
      {
        assertion = redisActuallyCreateLocally -> (!cfg.redis.enableUnixSocket || cfg.redis.passwordFile == null);
        message = ''
          <option>services.mastodon.redis.enableUnixSocket</option> needs to be disabled if
            <option>services.mastodon.redis.passwordFile</option> is used.
        '';
      }
      {
        assertion = databaseActuallyCreateLocally -> (cfg.user == cfg.database.user && cfg.database.user == cfg.database.name);
        message = ''
          For local automatic database provisioning (services.mastodon.database.createLocally == true) with peer
            authentication (services.mastodon.database.host == "/run/postgresql") to work services.mastodon.user
            and services.mastodon.database.user must be identical.
        '';
      }
      {
        assertion = !databaseActuallyCreateLocally -> (cfg.database.host != "/run/postgresql");
        message = ''
          <option>services.mastodon.database.host</option> needs to be set if
            <option>services.mastodon.database.createLocally</option> is not enabled.
        '';
      }
      {
        assertion = cfg.smtp.authenticate -> (cfg.smtp.user != null);
        message = ''
          <option>services.mastodon.smtp.user</option> needs to be set if
            <option>services.mastodon.smtp.authenticate</option> is enabled.
        '';
      }
      {
        assertion = cfg.smtp.authenticate -> (cfg.smtp.passwordFile != null);
        message = ''
          <option>services.mastodon.smtp.passwordFile</option> needs to be set if
            <option>services.mastodon.smtp.authenticate</option> is enabled.
        '';
      }
      {
        assertion = 1 ==
          (lib.count (x: x)
            (lib.mapAttrsToList
              (_: v: builtins.elem "scheduler" v.jobClasses || v.jobClasses == [ ])
              cfg.sidekiqProcesses));
        message = "There must be exactly one Sidekiq queue in services.mastodon.sidekiqProcesses with jobClass \"scheduler\".";
      }
    ];

    environment.systemPackages = [ mastodonTootctl ];

    systemd.targets.mastodon = {
      description = "Target for all Mastodon services";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };

    systemd.targets.mastodon-streaming = {
      description = "Target for all Mastodon streaming services";
      wantedBy = [ "multi-user.target" "mastodon.target" ];
      after = [ "network.target" ];
    };

    systemd.services.mastodon-init-dirs = {
      script = ''
        umask 077

        if ! test -f ${cfg.secretKeyBaseFile}; then
          mkdir -p $(dirname ${cfg.secretKeyBaseFile})
          bin/rake secret > ${cfg.secretKeyBaseFile}
        fi
        if ! test -f ${cfg.otpSecretFile}; then
          mkdir -p $(dirname ${cfg.otpSecretFile})
          bin/rake secret > ${cfg.otpSecretFile}
        fi
        if ! test -f ${cfg.vapidPrivateKeyFile}; then
          mkdir -p $(dirname ${cfg.vapidPrivateKeyFile}) $(dirname ${cfg.vapidPublicKeyFile})
          keypair=$(bin/rake webpush:generate_keys)
          echo $keypair | grep --only-matching "Private -> [^ ]\+" | sed 's/^Private -> //' > ${cfg.vapidPrivateKeyFile}
          echo $keypair | grep --only-matching "Public -> [^ ]\+" | sed 's/^Public -> //' > ${cfg.vapidPublicKeyFile}
        fi

        cat > /var/lib/mastodon/.secrets_env <<EOF
        SECRET_KEY_BASE="$(cat ${cfg.secretKeyBaseFile})"
        OTP_SECRET="$(cat ${cfg.otpSecretFile})"
        VAPID_PRIVATE_KEY="$(cat ${cfg.vapidPrivateKeyFile})"
        VAPID_PUBLIC_KEY="$(cat ${cfg.vapidPublicKeyFile})"
      '' + lib.optionalString (cfg.redis.passwordFile != null)''
        REDIS_PASSWORD="$(cat ${cfg.redis.passwordFile})"
      '' + lib.optionalString (cfg.database.passwordFile != null) ''
        DB_PASS="$(cat ${cfg.database.passwordFile})"
      '' + lib.optionalString cfg.smtp.authenticate ''
        SMTP_PASSWORD="$(cat ${cfg.smtp.passwordFile})"
      '' + lib.optionalString (cfg.elasticsearch.passwordFile != null) ''
        ES_PASS="$(cat ${cfg.elasticsearch.passwordFile})"
      '' + ''
        EOF
      '';
      environment = env;
      serviceConfig = {
        Type = "oneshot";
        SyslogIdentifier = "mastodon-init-dirs";
        # System Call Filtering
        SystemCallFilter = [ ("~" + lib.concatStringsSep " " (systemCallsList ++ [ "@resources" ])) "@chown" "pipe" "pipe2" ];
      } // cfgService;

      after = [ "network.target" ];
    };

    systemd.services.mastodon-init-db = lib.mkIf cfg.automaticMigrations {
      script = lib.optionalString (!databaseActuallyCreateLocally) ''
        umask 077
        export PGPASSWORD="$(cat '${cfg.database.passwordFile}')"
      '' + ''
        result="$(psql -t --csv -c \
            "select count(*) from pg_class c \
            join pg_namespace s on s.oid = c.relnamespace \
            where s.nspname not in ('pg_catalog', 'pg_toast', 'information_schema') \
            and s.nspname not like 'pg_temp%';")" || error_code=$?
        if [ "''${error_code:-0}" -ne 0 ]; then
          echo "Failure checking if database is seeded. psql gave exit code $error_code"
          exit "$error_code"
        fi
        if [ "$result" -eq 0 ]; then
          echo "Seeding database"
          SAFETY_ASSURED=1 rails db:schema:load
          rails db:seed
        else
          echo "Migrating database (this might be a noop)"
          rails db:migrate
        fi
      '' +  lib.optionalString (!databaseActuallyCreateLocally) ''
        unset PGPASSWORD
      '';
      path = [ cfg.package pkgs.postgresql ];
      environment = env // lib.optionalAttrs (!databaseActuallyCreateLocally) {
        PGHOST = cfg.database.host;
        PGPORT = toString cfg.database.port;
        PGDATABASE = cfg.database.name;
        PGUSER = cfg.database.user;
      };
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = [ "/var/lib/mastodon/.secrets_env" ] ++ cfg.extraEnvFiles;
        WorkingDirectory = cfg.package;
        # System Call Filtering
        SystemCallFilter = [ ("~" + lib.concatStringsSep " " (systemCallsList ++ [ "@resources" ])) "@chown" "pipe" "pipe2" ];
      } // cfgService;
      after = [ "network.target" "mastodon-init-dirs.service" ]
        ++ lib.optional databaseActuallyCreateLocally "postgresql.service";
      requires = [ "mastodon-init-dirs.service" ]
        ++ lib.optional databaseActuallyCreateLocally "postgresql.service";
    };

    systemd.services.mastodon-web = {
      after = [ "network.target" "mastodon-init-dirs.service" ]
        ++ lib.optional redisActuallyCreateLocally "redis-mastodon.service"
        ++ lib.optional databaseActuallyCreateLocally "postgresql.service"
        ++ lib.optional cfg.automaticMigrations "mastodon-init-db.service";
      requires = [ "mastodon-init-dirs.service" ]
        ++ lib.optional redisActuallyCreateLocally "redis-mastodon.service"
        ++ lib.optional databaseActuallyCreateLocally "postgresql.service"
        ++ lib.optional cfg.automaticMigrations "mastodon-init-db.service";
      wantedBy = [ "mastodon.target" ];
      description = "Mastodon web";
      environment = env // (if cfg.enableUnixSocket
        then { SOCKET = "/run/mastodon-web/web.socket"; }
        else { PORT = toString(cfg.webPort); }
      );
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/puma -C config/puma.rb";
        Restart = "always";
        RestartSec = 20;
        EnvironmentFile = [ "/var/lib/mastodon/.secrets_env" ] ++ cfg.extraEnvFiles;
        WorkingDirectory = cfg.package;
        # Runtime directory and mode
        RuntimeDirectory = "mastodon-web";
        RuntimeDirectoryMode = "0750";
        # System Call Filtering
        SystemCallFilter = [ ("~" + lib.concatStringsSep " " systemCallsList) "@chown" "pipe" "pipe2" ];
      } // cfgService;
      path = with pkgs; [ ffmpeg-headless file imagemagick ];
    };

    systemd.services.mastodon-media-auto-remove = lib.mkIf cfg.mediaAutoRemove.enable {
      description = "Mastodon media auto remove";
      environment = env;
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = [ "/var/lib/mastodon/.secrets_env" ] ++ cfg.extraEnvFiles;
      } // cfgService;
      script = let
        olderThanDays = toString cfg.mediaAutoRemove.olderThanDays;
      in ''
        ${cfg.package}/bin/tootctl media remove --days=${olderThanDays}
        ${cfg.package}/bin/tootctl preview_cards remove --days=${olderThanDays}
      '';
      startAt = cfg.mediaAutoRemove.startAt;
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      recommendedProxySettings = true; # required for redirections to work
      virtualHosts."${cfg.localDomain}" = {
        root = "${cfg.package}/public/";
        # mastodon only supports https, but you can override this if you offload tls elsewhere.
        forceSSL = lib.mkDefault true;
        enableACME = lib.mkDefault true;

        locations."/system/".alias = "/var/lib/mastodon/public-system/";

        locations."/" = {
          tryFiles = "$uri @proxy";
        };

        locations."@proxy" = {
          proxyPass = (if cfg.enableUnixSocket then "http://unix:/run/mastodon-web/web.socket" else "http://127.0.0.1:${toString(cfg.webPort)}");
          proxyWebsockets = true;
        };

        locations."/api/v1/streaming/" = {
          proxyPass = "http://mastodon-streaming";
          proxyWebsockets = true;
        };
      };
      upstreams.mastodon-streaming = {
        extraConfig = ''
          least_conn;
        '';
        servers = builtins.listToAttrs
          (map (i: {
            name = "unix:/run/mastodon-streaming/streaming-${toString i}.socket";
            value = { };
          }) (lib.range 1 cfg.streamingProcesses));
      };
    };

    services.postfix = lib.mkIf (cfg.smtp.createLocally && cfg.smtp.host == "127.0.0.1") {
      enable = true;
      hostname = lib.mkDefault "${cfg.localDomain}";
    };
    services.redis.servers.mastodon = lib.mkIf redisActuallyCreateLocally (lib.mkMerge [
      {
        enable = true;
      }
      (lib.mkIf (!cfg.redis.enableUnixSocket) {
        port = cfg.redis.port;
      })
    ]);
    services.postgresql = lib.mkIf databaseActuallyCreateLocally {
      enable = true;
      ensureUsers = [
        {
          name = cfg.database.name;
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ cfg.database.name ];
    };

    users.users = lib.mkMerge [
      (lib.mkIf (cfg.user == "mastodon") {
        mastodon = {
          isSystemUser = true;
          home = cfg.package;
          inherit (cfg) group;
        };
      })
      (lib.attrsets.setAttrByPath [ cfg.user "packages" ] [ cfg.package pkgs.imagemagick ])
      (lib.mkIf (cfg.redis.createLocally && cfg.redis.enableUnixSocket) {${config.services.mastodon.user}.extraGroups = [ "redis-mastodon" ];})
    ];

    users.groups.${cfg.group}.members = lib.optional cfg.configureNginx config.services.nginx.user;
  }
  { systemd.services = lib.mkMerge [ sidekiqUnits streamingUnits ]; }
  ]);

  meta.maintainers = with lib.maintainers; [ happy-river erictapen ];

}
