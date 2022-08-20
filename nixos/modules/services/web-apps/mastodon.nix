{ config, lib, pkgs, ... }:

let
  cfg = config.services.mastodon;
  # We only want to create a database if we're actually going to connect to it.
  databaseActuallyCreateLocally = cfg.database.createLocally && cfg.database.host == "/run/postgresql";

  env = {
    RAILS_ENV = "production";
    NODE_ENV = "production";

    LD_PRELOAD = "${pkgs.jemalloc}/lib/libjemalloc.so";

    # mastodon-web concurrency.
    WEB_CONCURRENCY = toString cfg.webProcesses;
    MAX_THREADS = toString cfg.webThreads;

    # mastodon-streaming concurrency.
    STREAMING_CLUSTER_NUM = toString cfg.streamingProcesses;

    DB_USER = cfg.database.user;

    REDIS_HOST = cfg.redis.host;
    REDIS_PORT = toString(cfg.redis.port);
    DB_HOST = cfg.database.host;
    DB_PORT = toString(cfg.database.port);
    DB_NAME = cfg.database.name;
    LOCAL_DOMAIN = cfg.localDomain;
    SMTP_SERVER = cfg.smtp.host;
    SMTP_PORT = toString(cfg.smtp.port);
    SMTP_FROM_ADDRESS = cfg.smtp.fromAddress;
    PAPERCLIP_ROOT_PATH = "/var/lib/mastodon/public-system";
    PAPERCLIP_ROOT_URL = "/system";
    ES_ENABLED = if (cfg.elasticsearch.host != null) then "true" else "false";
    ES_HOST = cfg.elasticsearch.host;
    ES_PORT = toString(cfg.elasticsearch.port);

    TRUSTED_PROXY_IP = cfg.trustedProxy;
  }
  // (if cfg.smtp.authenticate then { SMTP_LOGIN  = cfg.smtp.user; } else {})
  // cfg.extraConfig;

  systemCallsList = [ "@cpu-emulation" "@debug" "@keyring" "@ipc" "@mount" "@obsolete" "@privileged" "@setuid" ];

  cfgService = {
    # User and group
    User = cfg.user;
    Group = cfg.group;
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
      if value != null then [
        "${name}=\"${toString value}\""
      ] else []
    ) env))));

  mastodonEnv = pkgs.writeShellScriptBin "mastodon-env" ''
    set -a
    export RAILS_ROOT="${cfg.package}"
    source "${envFile}"
    source /var/lib/mastodon/.secrets_env
    eval -- "\$@"
  '';

in {

  options = {
    services.mastodon = {
      enable = lib.mkEnableOption "Mastodon, a federated social network server";

      configureNginx = lib.mkOption {
        description = ''
          Configure nginx as a reverse proxy for mastodon.
          Note that this makes some assumptions on your setup, and sets settings that will
          affect other virtualHosts running on your nginx instance, if any.
          Alternatively you can configure a reverse-proxy of your choice to serve these paths:

          <literal>/ -> $(nix-instantiate --eval '&lt;nixpkgs&gt;' -A mastodon.outPath)/public</literal>

          <literal>/ -> 127.0.0.1:{{ webPort }} </literal>(If there was no file in the directory above.)

          <literal>/system/ -> /var/lib/mastodon/public-system/</literal>

          <literal>/api/v1/streaming/ -> 127.0.0.1:{{ streamingPort }}</literal>

          Make sure that websockets are forwarded properly. You might want to set up caching
          of some requests. Take a look at mastodon's provided nginx configuration at
          <literal>https://github.com/mastodon/mastodon/blob/master/dist/nginx.conf</literal>.
        '';
        type = lib.types.bool;
        default = false;
      };

      user = lib.mkOption {
        description = lib.mdDoc ''
          User under which mastodon runs. If it is set to "mastodon",
          that user will be created, otherwise it should be set to the
          name of a user created elsewhere.  In both cases,
          `mastodon` and a package containing only
          the shell script `mastodon-env` will be added to
          the user's package set. To run a command from
          `mastodon` such as `tootctl`
          with the environment configured by this module use
          `mastodon-env`, as in:

          `mastodon-env tootctl accounts create newuser --email newuser@example.com`
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

      streamingPort = lib.mkOption {
        description = lib.mdDoc "TCP port used by the mastodon-streaming service.";
        type = lib.types.port;
        default = 55000;
      };
      streamingProcesses = lib.mkOption {
        description = lib.mdDoc ''
          Processes used by the mastodon-streaming service.
          Defaults to the number of CPU cores minus one.
        '';
        type = lib.types.nullOr lib.types.int;
        default = null;
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
        description = lib.mdDoc "Worker threads used by the mastodon-sidekiq service.";
        type = lib.types.int;
        default = 25;
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
          type = lib.types.int;
          default = 5432;
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
          default = "/var/lib/mastodon/secrets/db-password";
          example = "/run/keys/mastodon-db-password";
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
          description = lib.mdDoc "SMTP login name.";
          type = lib.types.str;
        };

        passwordFile = lib.mkOption {
          description = lib.mdDoc ''
            Path to file containing the SMTP password.
          '';
          default = "/var/lib/mastodon/secrets/smtp-password";
          example = "/run/keys/mastodon-smtp-password";
          type = lib.types.str;
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

      automaticMigrations = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc ''
          Do automatic database migrations.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = databaseActuallyCreateLocally -> (cfg.user == cfg.database.user);
        message = ''For local automatic database provisioning (services.mastodon.database.createLocally == true) with peer authentication (services.mastodon.database.host == "/run/postgresql") to work services.mastodon.user and services.mastodon.database.user must be identical.'';
      }
    ];

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
        DB_PASS="$(cat ${cfg.database.passwordFile})"
      '' + (if cfg.smtp.authenticate then ''
        SMTP_PASSWORD="$(cat ${cfg.smtp.passwordFile})"
      '' else "") + ''
        EOF
      '';
      environment = env;
      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = cfg.package;
        # System Call Filtering
        SystemCallFilter = [ ("~" + lib.concatStringsSep " " (systemCallsList ++ [ "@resources" ])) "@chown" "pipe" "pipe2" ];
      } // cfgService;

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.mastodon-init-db = lib.mkIf cfg.automaticMigrations {
      script = ''
        if [ `psql ${cfg.database.name} -c \
                "select count(*) from pg_class c \
                join pg_namespace s on s.oid = c.relnamespace \
                where s.nspname not in ('pg_catalog', 'pg_toast', 'information_schema') \
                and s.nspname not like 'pg_temp%';" | sed -n 3p` -eq 0 ]; then
          SAFETY_ASSURED=1 rails db:schema:load
          rails db:seed
        else
          rails db:migrate
        fi
      '';
      path = [ cfg.package pkgs.postgresql ];
      environment = env;
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = "/var/lib/mastodon/.secrets_env";
        WorkingDirectory = cfg.package;
        # System Call Filtering
        SystemCallFilter = [ ("~" + lib.concatStringsSep " " (systemCallsList ++ [ "@resources" ])) "@chown" "pipe" "pipe2" ];
      } // cfgService;
      after = [ "mastodon-init-dirs.service" "network.target" ] ++ (if databaseActuallyCreateLocally then [ "postgresql.service" ] else []);
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.mastodon-streaming = {
      after = [ "network.target" ]
        ++ (if databaseActuallyCreateLocally then [ "postgresql.service" ] else [])
        ++ (if cfg.automaticMigrations then [ "mastodon-init-db.service" ] else [ "mastodon-init-dirs.service" ]);
      description = "Mastodon streaming";
      wantedBy = [ "multi-user.target" ];
      environment = env // (if cfg.enableUnixSocket
        then { SOCKET = "/run/mastodon-streaming/streaming.socket"; }
        else { PORT = toString(cfg.streamingPort); }
      );
      serviceConfig = {
        ExecStart = "${cfg.package}/run-streaming.sh";
        Restart = "always";
        RestartSec = 20;
        EnvironmentFile = "/var/lib/mastodon/.secrets_env";
        WorkingDirectory = cfg.package;
        # Runtime directory and mode
        RuntimeDirectory = "mastodon-streaming";
        RuntimeDirectoryMode = "0750";
        # System Call Filtering
        SystemCallFilter = [ ("~" + lib.concatStringsSep " " (systemCallsList ++ [ "@memlock" "@resources" ])) "pipe" "pipe2" ];
      } // cfgService;
    };

    systemd.services.mastodon-web = {
      after = [ "network.target" ]
        ++ (if databaseActuallyCreateLocally then [ "postgresql.service" ] else [])
        ++ (if cfg.automaticMigrations then [ "mastodon-init-db.service" ] else [ "mastodon-init-dirs.service" ]);
      description = "Mastodon web";
      wantedBy = [ "multi-user.target" ];
      environment = env // (if cfg.enableUnixSocket
        then { SOCKET = "/run/mastodon-web/web.socket"; }
        else { PORT = toString(cfg.webPort); }
      );
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/puma -C config/puma.rb";
        Restart = "always";
        RestartSec = 20;
        EnvironmentFile = "/var/lib/mastodon/.secrets_env";
        WorkingDirectory = cfg.package;
        # Runtime directory and mode
        RuntimeDirectory = "mastodon-web";
        RuntimeDirectoryMode = "0750";
        # System Call Filtering
        SystemCallFilter = [ ("~" + lib.concatStringsSep " " systemCallsList) "@chown" "pipe" "pipe2" ];
      } // cfgService;
      path = with pkgs; [ file imagemagick ffmpeg ];
    };

    systemd.services.mastodon-sidekiq = {
      after = [ "network.target" ]
        ++ (if databaseActuallyCreateLocally then [ "postgresql.service" ] else [])
        ++ (if cfg.automaticMigrations then [ "mastodon-init-db.service" ] else [ "mastodon-init-dirs.service" ]);
      description = "Mastodon sidekiq";
      wantedBy = [ "multi-user.target" ];
      environment = env // {
        PORT = toString(cfg.sidekiqPort);
        DB_POOL = toString cfg.sidekiqThreads;
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/sidekiq -c ${toString cfg.sidekiqThreads} -r ${cfg.package}";
        Restart = "always";
        RestartSec = 20;
        EnvironmentFile = "/var/lib/mastodon/.secrets_env";
        WorkingDirectory = cfg.package;
        # System Call Filtering
        SystemCallFilter = [ ("~" + lib.concatStringsSep " " systemCallsList) "@chown" "pipe" "pipe2" ];
      } // cfgService;
      path = with pkgs; [ file imagemagick ffmpeg ];
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      recommendedProxySettings = true; # required for redirections to work
      virtualHosts."${cfg.localDomain}" = {
        root = "${cfg.package}/public/";
        forceSSL = true; # mastodon only supports https
        enableACME = true;

        locations."/system/".alias = "/var/lib/mastodon/public-system/";

        locations."/" = {
          tryFiles = "$uri @proxy";
        };

        locations."@proxy" = {
          proxyPass = (if cfg.enableUnixSocket then "http://unix:/run/mastodon-web/web.socket" else "http://127.0.0.1:${toString(cfg.webPort)}");
          proxyWebsockets = true;
        };

        locations."/api/v1/streaming/" = {
          proxyPass = (if cfg.enableUnixSocket then "http://unix:/run/mastodon-streaming/streaming.socket" else "http://127.0.0.1:${toString(cfg.streamingPort)}/");
          proxyWebsockets = true;
        };
      };
    };

    services.postfix = lib.mkIf (cfg.smtp.createLocally && cfg.smtp.host == "127.0.0.1") {
      enable = true;
      hostname = lib.mkDefault "${cfg.localDomain}";
    };
    services.redis.servers.mastodon = lib.mkIf (cfg.redis.createLocally && cfg.redis.host == "127.0.0.1") {
      enable = true;
      port = cfg.redis.port;
      bind = "127.0.0.1";
    };
    services.postgresql = lib.mkIf databaseActuallyCreateLocally {
      enable = true;
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions."DATABASE ${cfg.database.name}" = "ALL PRIVILEGES";
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
      (lib.attrsets.setAttrByPath [ cfg.user "packages" ] [ cfg.package mastodonEnv ])
    ];

    users.groups.${cfg.group}.members = lib.optional cfg.configureNginx config.services.nginx.user;
  };

  meta.maintainers = with lib.maintainers; [ happy-river erictapen ];

}
