{ config, options, lib, pkgs, utils, ... }:

let
  json = pkgs.formats.json {};

  cfg = config.services.discourse;
  opt = options.services.discourse;

  # Keep in sync with https://github.com/discourse/discourse_docker/blob/main/image/base/slim.Dockerfile#L5
  upstreamPostgresqlVersion = lib.getVersion pkgs.postgresql_13;

  postgresqlPackage = if config.services.postgresql.enable then
                        config.services.postgresql.package
                      else
                        pkgs.postgresql;

  postgresqlVersion = lib.getVersion postgresqlPackage;

  # We only want to create a database if we're actually going to connect to it.
  databaseActuallyCreateLocally = cfg.database.createLocally && cfg.database.host == null;

  tlsEnabled = (cfg.enableACME
                || cfg.sslCertificate != null
                || cfg.sslCertificateKey != null);
in
{
  options = {
    services.discourse = {
      enable = lib.mkEnableOption (lib.mdDoc "Discourse, an open source discussion platform");

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.discourse;
        apply = p: p.override {
          plugins = lib.unique (p.enabledPlugins ++ cfg.plugins);
        };
        defaultText = lib.literalExpression "pkgs.discourse";
        description = lib.mdDoc ''
          The discourse package to use.
        '';
      };

      hostname = lib.mkOption {
        type = lib.types.str;
        default = if config.networking.domain != null then
                    config.networking.fqdn
                  else
                    config.networking.hostName;
        defaultText = lib.literalExpression "config.networking.fqdn";
        example = "discourse.example.com";
        description = lib.mdDoc ''
          The hostname to serve Discourse on.
        '';
      };

      secretKeyBaseFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        example = "/run/keys/secret_key_base";
        description = lib.mdDoc ''
          The path to a file containing the
          `secret_key_base` secret.

          Discourse uses `secret_key_base` to encrypt
          the cookie store, which contains session data, and to digest
          user auth tokens.

          Needs to be a 64 byte long string of hexadecimal
          characters. You can generate one by running

          ```
          openssl rand -hex 64 >/path/to/secret_key_base_file
          ```

          This should be a string, not a nix path, since nix paths are
          copied into the world-readable nix store.
        '';
      };

      sslCertificate = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        example = "/run/keys/ssl.cert";
        description = lib.mdDoc ''
          The path to the server SSL certificate. Set this to enable
          SSL.
        '';
      };

      sslCertificateKey = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        example = "/run/keys/ssl.key";
        description = lib.mdDoc ''
          The path to the server SSL certificate key. Set this to
          enable SSL.
        '';
      };

      enableACME = lib.mkOption {
        type = lib.types.bool;
        default = cfg.sslCertificate == null && cfg.sslCertificateKey == null;
        defaultText = lib.literalMD ''
          `true`, unless {option}`services.discourse.sslCertificate`
          and {option}`services.discourse.sslCertificateKey` are set.
        '';
        description = lib.mdDoc ''
          Whether an ACME certificate should be used to secure
          connections to the server.
        '';
      };

      backendSettings = lib.mkOption {
        type = with lib.types; attrsOf (nullOr (oneOf [ str int bool float ]));
        default = {};
        example = lib.literalExpression ''
          {
            max_reqs_per_ip_per_minute = 300;
            max_reqs_per_ip_per_10_seconds = 60;
            max_asset_reqs_per_ip_per_10_seconds = 250;
            max_reqs_per_ip_mode = "warn+block";
          };
        '';
        description = lib.mdDoc ''
          Additional settings to put in the
          {file}`discourse.conf` file.

          Look in the
          [discourse_defaults.conf](https://github.com/discourse/discourse/blob/master/config/discourse_defaults.conf)
          file in the upstream distribution to find available options.

          Setting an option to `null` means
          “define variable, but leave right-hand side empty”.
        '';
      };

      siteSettings = lib.mkOption {
        type = json.type;
        default = {};
        example = lib.literalExpression ''
          {
            required = {
              title = "My Cats";
              site_description = "Discuss My Cats (and be nice plz)";
            };
            login = {
              enable_github_logins = true;
              github_client_id = "a2f6dfe838cb3206ce20";
              github_client_secret._secret = /run/keys/discourse_github_client_secret;
            };
          };
        '';
        description = lib.mdDoc ''
          Discourse site settings. These are the settings that can be
          changed from the UI. This only defines their default values:
          they can still be overridden from the UI.

          Available settings can be found by looking in the
          [site_settings.yml](https://github.com/discourse/discourse/blob/master/config/site_settings.yml)
          file of the upstream distribution. To find a setting's path,
          you only need to care about the first two levels; i.e. its
          category and name. See the example.

          Settings containing secret data should be set to an
          attribute set containing the attribute
          `_secret` - a string pointing to a file
          containing the value the option should be set to. See the
          example to get a better picture of this: in the resulting
          {file}`config/nixos_site_settings.json` file,
          the `login.github_client_secret` key will
          be set to the contents of the
          {file}`/run/keys/discourse_github_client_secret`
          file.
        '';
      };

      admin = {
        skipCreate = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = lib.mdDoc ''
            Do not create the admin account, instead rely on other
            existing admin accounts.
          '';
        };

        email = lib.mkOption {
          type = lib.types.str;
          example = "admin@example.com";
          description = lib.mdDoc ''
            The admin user email address.
          '';
        };

        username = lib.mkOption {
          type = lib.types.str;
          example = "admin";
          description = lib.mdDoc ''
            The admin user username.
          '';
        };

        fullName = lib.mkOption {
          type = lib.types.str;
          description = lib.mdDoc ''
            The admin user's full name.
          '';
        };

        passwordFile = lib.mkOption {
          type = lib.types.path;
          description = lib.mdDoc ''
            A path to a file containing the admin user's password.

            This should be a string, not a nix path, since nix paths are
            copied into the world-readable nix store.
          '';
        };
      };

      nginx.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether an `nginx` virtual host should be
          set up to serve Discourse. Only disable if you're planning
          to use a different web server, which is not recommended.
        '';
      };

      database = {
        pool = lib.mkOption {
          type = lib.types.int;
          default = 8;
          description = lib.mdDoc ''
            Database connection pool size.
          '';
        };

        host = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = lib.mdDoc ''
            Discourse database hostname. `null` means
            “prefer local unix socket connection”.
          '';
        };

        passwordFile = lib.mkOption {
          type = with lib.types; nullOr path;
          default = null;
          description = lib.mdDoc ''
            File containing the Discourse database user password.

            This should be a string, not a nix path, since nix paths are
            copied into the world-readable nix store.
          '';
        };

        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = lib.mdDoc ''
            Whether a database should be automatically created on the
            local host. Set this to `false` if you plan
            on provisioning a local database yourself. This has no effect
            if {option}`services.discourse.database.host` is customized.
          '';
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "discourse";
          description = lib.mdDoc ''
            Discourse database name.
          '';
        };

        username = lib.mkOption {
          type = lib.types.str;
          default = "discourse";
          description = lib.mdDoc ''
            Discourse database user.
          '';
        };

        ignorePostgresqlVersion = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = lib.mdDoc ''
            Whether to allow other versions of PostgreSQL than the
            recommended one. Only effective when
            {option}`services.discourse.database.createLocally`
            is enabled.
          '';
        };
      };

      redis = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          description = lib.mdDoc ''
            Redis server hostname.
          '';
        };

        passwordFile = lib.mkOption {
          type = with lib.types; nullOr path;
          default = null;
          description = lib.mdDoc ''
            File containing the Redis password.

            This should be a string, not a nix path, since nix paths are
            copied into the world-readable nix store.
          '';
        };

        dbNumber = lib.mkOption {
          type = lib.types.int;
          default = 0;
          description = lib.mdDoc ''
            Redis database number.
          '';
        };

        useSSL = lib.mkOption {
          type = lib.types.bool;
          default = cfg.redis.host != "localhost";
          defaultText = lib.literalExpression ''config.${opt.redis.host} != "localhost"'';
          description = lib.mdDoc ''
            Connect to Redis with SSL.
          '';
        };
      };

      mail = {
        notificationEmailAddress = lib.mkOption {
          type = lib.types.str;
          default = "${if cfg.mail.incoming.enable then "notifications" else "noreply"}@${cfg.hostname}";
          defaultText = lib.literalExpression ''
            "''${if config.services.discourse.mail.incoming.enable then "notifications" else "noreply"}@''${config.services.discourse.hostname}"
          '';
          description = lib.mdDoc ''
            The `from:` email address used when
            sending all essential system emails. The domain specified
            here must have SPF, DKIM and reverse PTR records set
            correctly for email to arrive.
          '';
        };

        contactEmailAddress = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = lib.mdDoc ''
            Email address of key contact responsible for this
            site. Used for critical notifications, as well as on the
            `/about` contact form for urgent matters.
          '';
        };

        outgoing = {
          serverAddress = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            description = lib.mdDoc ''
              The address of the SMTP server Discourse should use to
              send email.
            '';
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 25;
            description = lib.mdDoc ''
              The port of the SMTP server Discourse should use to
              send email.
            '';
          };

          username = lib.mkOption {
            type = with lib.types; nullOr str;
            default = null;
            description = lib.mdDoc ''
              The username of the SMTP server.
            '';
          };

          passwordFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = lib.mdDoc ''
              A file containing the password of the SMTP server account.

              This should be a string, not a nix path, since nix paths
              are copied into the world-readable nix store.
            '';
          };

          domain = lib.mkOption {
            type = lib.types.str;
            default = cfg.hostname;
            defaultText = lib.literalExpression "config.${opt.hostname}";
            description = lib.mdDoc ''
              HELO domain to use for outgoing mail.
            '';
          };

          authentication = lib.mkOption {
            type = with lib.types; nullOr (enum ["plain" "login" "cram_md5"]);
            default = null;
            description = lib.mdDoc ''
              Authentication type to use, see http://api.rubyonrails.org/classes/ActionMailer/Base.html
            '';
          };

          enableStartTLSAuto = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = lib.mdDoc ''
              Whether to try to use StartTLS.
            '';
          };

          opensslVerifyMode = lib.mkOption {
            type = lib.types.str;
            default = "peer";
            description = lib.mdDoc ''
              How OpenSSL checks the certificate, see http://api.rubyonrails.org/classes/ActionMailer/Base.html
            '';
          };

          forceTLS = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = lib.mdDoc ''
              Force implicit TLS as per RFC 8314 3.3.
            '';
          };
        };

        incoming = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = lib.mdDoc ''
              Whether to set up Postfix to receive incoming mail.
            '';
          };

          replyEmailAddress = lib.mkOption {
            type = lib.types.str;
            default = "%{reply_key}@${cfg.hostname}";
            defaultText = lib.literalExpression ''"%{reply_key}@''${config.services.discourse.hostname}"'';
            description = lib.mdDoc ''
              Template for reply by email incoming email address, for
              example: %{reply_key}@reply.example.com or
              replies+%{reply_key}@example.com
            '';
          };

          mailReceiverPackage = lib.mkOption {
            type = lib.types.package;
            default = pkgs.discourse-mail-receiver;
            defaultText = lib.literalExpression "pkgs.discourse-mail-receiver";
            description = lib.mdDoc ''
              The discourse-mail-receiver package to use.
            '';
          };

          apiKeyFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = lib.mdDoc ''
              A file containing the Discourse API key used to add
              posts and messages from mail. If left at its default
              value `null`, one will be automatically
              generated.

              This should be a string, not a nix path, since nix paths
              are copied into the world-readable nix store.
            '';
          };
        };
      };

      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        example = lib.literalExpression ''
          with config.services.discourse.package.plugins; [
            discourse-canned-replies
            discourse-github
          ];
        '';
        description = lib.mdDoc ''
          Plugins to install as part of Discourse, expressed as a list of derivations.
        '';
      };

      sidekiqProcesses = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = lib.mdDoc ''
          How many Sidekiq processes should be spawned.
        '';
      };

      unicornTimeout = lib.mkOption {
        type = lib.types.int;
        default = 30;
        description = lib.mdDoc ''
          Time in seconds before a request to Unicorn times out.

          This can be raised if the system Discourse is running on is
          too slow to handle many requests within 30 seconds.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.database.host != null) -> (cfg.database.passwordFile != null);
        message = "When services.gitlab.database.host is customized, services.discourse.database.passwordFile must be set!";
      }
      {
        assertion = cfg.hostname != "";
        message = "Could not automatically determine hostname, set service.discourse.hostname manually.";
      }
      {
        assertion = cfg.database.ignorePostgresqlVersion || (databaseActuallyCreateLocally -> upstreamPostgresqlVersion == postgresqlVersion);
        message = "The PostgreSQL version recommended for use with Discourse is ${upstreamPostgresqlVersion}, you're using ${postgresqlVersion}. "
                  + "Either update your PostgreSQL package to the correct version or set services.discourse.database.ignorePostgresqlVersion. "
                  + "See https://nixos.org/manual/nixos/stable/index.html#module-postgresql for details on how to upgrade PostgreSQL.";
      }
    ];


    # Default config values are from `config/discourse_defaults.conf`
    # upstream.
    services.discourse.backendSettings = lib.mapAttrs (_: lib.mkDefault) {
      db_pool = cfg.database.pool;
      db_timeout = 5000;
      db_connect_timeout = 5;
      db_socket = null;
      db_host = cfg.database.host;
      db_backup_host = null;
      db_port = null;
      db_backup_port = 5432;
      db_name = cfg.database.name;
      db_username = if databaseActuallyCreateLocally then "discourse" else cfg.database.username;
      db_password = cfg.database.passwordFile;
      db_prepared_statements = false;
      db_replica_host = null;
      db_replica_port = null;
      db_advisory_locks = true;

      inherit (cfg) hostname;
      backup_hostname = null;

      smtp_address = cfg.mail.outgoing.serverAddress;
      smtp_port = cfg.mail.outgoing.port;
      smtp_domain = cfg.mail.outgoing.domain;
      smtp_user_name = cfg.mail.outgoing.username;
      smtp_password = cfg.mail.outgoing.passwordFile;
      smtp_authentication = cfg.mail.outgoing.authentication;
      smtp_enable_start_tls = cfg.mail.outgoing.enableStartTLSAuto;
      smtp_openssl_verify_mode = cfg.mail.outgoing.opensslVerifyMode;
      smtp_force_tls = cfg.mail.outgoing.forceTLS;

      load_mini_profiler = true;
      mini_profiler_snapshots_period = 0;
      mini_profiler_snapshots_transport_url = null;
      mini_profiler_snapshots_transport_auth_key = null;

      cdn_url = null;
      cdn_origin_hostname = null;
      developer_emails = null;

      redis_host = cfg.redis.host;
      redis_port = 6379;
      redis_replica_host = null;
      redis_replica_port = 6379;
      redis_db = cfg.redis.dbNumber;
      redis_password = cfg.redis.passwordFile;
      redis_skip_client_commands = false;
      redis_use_ssl = cfg.redis.useSSL;

      message_bus_redis_enabled = false;
      message_bus_redis_host = "localhost";
      message_bus_redis_port = 6379;
      message_bus_redis_replica_host = null;
      message_bus_redis_replica_port = 6379;
      message_bus_redis_db = 0;
      message_bus_redis_password = null;
      message_bus_redis_skip_client_commands = false;

      enable_cors = false;
      cors_origin = "";
      serve_static_assets = false;
      sidekiq_workers = 5;
      connection_reaper_age = 30;
      connection_reaper_interval = 30;
      relative_url_root = null;
      message_bus_max_backlog_size = 100;
      message_bus_clear_every = 50;
      secret_key_base = cfg.secretKeyBaseFile;
      fallback_assets_path = null;

      s3_bucket = null;
      s3_region = null;
      s3_access_key_id = null;
      s3_secret_access_key = null;
      s3_use_iam_profile = null;
      s3_cdn_url = null;
      s3_endpoint = null;
      s3_http_continue_timeout = null;
      s3_install_cors_rule = null;

      max_user_api_reqs_per_minute = 20;
      max_user_api_reqs_per_day = 2880;
      max_admin_api_reqs_per_minute = 60;
      max_reqs_per_ip_per_minute = 200;
      max_reqs_per_ip_per_10_seconds = 50;
      max_asset_reqs_per_ip_per_10_seconds = 200;
      max_reqs_per_ip_mode = "block";
      max_reqs_rate_limit_on_private = false;
      skip_per_ip_rate_limit_trust_level = 1;
      force_anonymous_min_queue_seconds = 1;
      force_anonymous_min_per_10_seconds = 3;
      background_requests_max_queue_length = 0.5;
      reject_message_bus_queue_seconds = 0.1;
      disable_search_queue_threshold = 1;
      max_old_rebakes_per_15_minutes = 300;
      max_logster_logs = 1000;
      refresh_maxmind_db_during_precompile_days = 2;
      maxmind_backup_path = null;
      maxmind_license_key = null;
      enable_performance_http_headers = false;
      enable_js_error_reporting = true;
      mini_scheduler_workers = 5;
      compress_anon_cache = false;
      anon_cache_store_threshold = 2;
      allowed_theme_repos = null;
      enable_email_sync_demon = false;
      max_digests_enqueued_per_30_mins_per_site = 10000;
      cluster_name = null;
      multisite_config_path = "config/multisite.yml";
      enable_long_polling = null;
      long_polling_interval = null;
    };

    services.redis.servers.discourse =
      lib.mkIf (lib.elem cfg.redis.host [ "localhost" "127.0.0.1" ]) {
        enable = true;
        bind = cfg.redis.host;
        port = cfg.backendSettings.redis_port;
      };

    services.postgresql = lib.mkIf databaseActuallyCreateLocally {
      enable = true;
      ensureUsers = [{ name = "discourse"; }];
    };

    # The postgresql module doesn't currently support concepts like
    # objects owners and extensions; for now we tack on what's needed
    # here.
    systemd.services.discourse-postgresql =
      let
        pgsql = config.services.postgresql;
      in
        lib.mkIf databaseActuallyCreateLocally {
          after = [ "postgresql.service" ];
          bindsTo = [ "postgresql.service" ];
          wantedBy = [ "discourse.service" ];
          partOf = [ "discourse.service" ];
          path = [
            pgsql.package
          ];
          script = ''
            set -o errexit -o pipefail -o nounset -o errtrace
            shopt -s inherit_errexit

            psql -tAc "SELECT 1 FROM pg_database WHERE datname = 'discourse'" | grep -q 1 || psql -tAc 'CREATE DATABASE "discourse" OWNER "discourse"'
            psql '${cfg.database.name}' -tAc "CREATE EXTENSION IF NOT EXISTS pg_trgm"
            psql '${cfg.database.name}' -tAc "CREATE EXTENSION IF NOT EXISTS hstore"
          '';

          serviceConfig = {
            User = pgsql.superUser;
            Type = "oneshot";
            RemainAfterExit = true;
          };
        };

    systemd.services.discourse = {
      wantedBy = [ "multi-user.target" ];
      after = [
        "redis-discourse.service"
        "postgresql.service"
        "discourse-postgresql.service"
      ];
      bindsTo = [
        "redis-discourse.service"
      ] ++ lib.optionals (cfg.database.host == null) [
        "postgresql.service"
        "discourse-postgresql.service"
      ];
      path = cfg.package.runtimeDeps ++ [
        postgresqlPackage
        pkgs.replace-secret
        cfg.package.rake
      ];
      environment = cfg.package.runtimeEnv // {
        UNICORN_TIMEOUT = builtins.toString cfg.unicornTimeout;
        UNICORN_SIDEKIQS = builtins.toString cfg.sidekiqProcesses;
        MALLOC_ARENA_MAX = "2";
      };

      preStart =
        let
          discourseKeyValue = lib.generators.toKeyValue {
            mkKeyValue = lib.flip lib.generators.mkKeyValueDefault " = " {
              mkValueString = v: with builtins;
                if isInt           v then toString v
                else if isString   v then ''"${v}"''
                else if true  ==   v then "true"
                else if false ==   v then "false"
                else if null  ==   v then ""
                else if isFloat    v then lib.strings.floatToString v
                else throw "unsupported type ${typeOf v}: ${(lib.generators.toPretty {}) v}";
            };
          };

          discourseConf = pkgs.writeText "discourse.conf" (discourseKeyValue cfg.backendSettings);

          mkSecretReplacement = file:
            lib.optionalString (file != null) ''
              replace-secret '${file}' '${file}' /run/discourse/config/discourse.conf
            '';

          mkAdmin = ''
            export ADMIN_EMAIL="${cfg.admin.email}"
            export ADMIN_NAME="${cfg.admin.fullName}"
            export ADMIN_USERNAME="${cfg.admin.username}"
            ADMIN_PASSWORD="$(<${cfg.admin.passwordFile})"
            export ADMIN_PASSWORD
            discourse-rake admin:create_noninteractively
          '';

        in ''
          set -o errexit -o pipefail -o nounset -o errtrace
          shopt -s inherit_errexit

          umask u=rwx,g=rx,o=

          rm -rf /var/lib/discourse/tmp/*

          cp -r ${cfg.package}/share/discourse/config.dist/* /run/discourse/config/
          cp -r ${cfg.package}/share/discourse/public.dist/* /run/discourse/public/
          ln -sf /var/lib/discourse/uploads /run/discourse/public/uploads
          ln -sf /var/lib/discourse/backups /run/discourse/public/backups

          (
              umask u=rwx,g=,o=

              ${utils.genJqSecretsReplacementSnippet
                  cfg.siteSettings
                  "/run/discourse/config/nixos_site_settings.json"
              }
              install -T -m 0600 -o discourse ${discourseConf} /run/discourse/config/discourse.conf
              ${mkSecretReplacement cfg.database.passwordFile}
              ${mkSecretReplacement cfg.mail.outgoing.passwordFile}
              ${mkSecretReplacement cfg.redis.passwordFile}
              ${mkSecretReplacement cfg.secretKeyBaseFile}
              chmod 0400 /run/discourse/config/discourse.conf
          )

          discourse-rake db:migrate >>/var/log/discourse/db_migration.log
          chmod -R u+w /var/lib/discourse/tmp/

          ${lib.optionalString (!cfg.admin.skipCreate) mkAdmin}

          discourse-rake themes:update
          discourse-rake uploads:regenerate_missing_optimized
        '';

      serviceConfig = {
        Type = "simple";
        User = "discourse";
        Group = "discourse";
        RuntimeDirectory = map (p: "discourse/" + p) [
          "config"
          "home"
          "assets/javascripts/plugins"
          "public"
          "sockets"
        ];
        RuntimeDirectoryMode = "0750";
        StateDirectory = map (p: "discourse/" + p) [
          "uploads"
          "backups"
          "tmp"
        ];
        StateDirectoryMode = "0750";
        LogsDirectory = "discourse";
        TimeoutSec = "infinity";
        Restart = "on-failure";
        WorkingDirectory = "${cfg.package}/share/discourse";

        RemoveIPC = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        RestrictSUIDSGID = true;
        ProtectSystem = "strict";
        ProtectHome = "read-only";

        ExecStart = "${cfg.package.rubyEnv}/bin/bundle exec config/unicorn_launcher -E production -c config/unicorn.conf.rb";
      };
    };

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      additionalModules = [ pkgs.nginxModules.brotli ];

      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      upstreams.discourse.servers."unix:/run/discourse/sockets/unicorn.sock" = {};

      appendHttpConfig = ''
        # inactive means we keep stuff around for 1440m minutes regardless of last access (1 week)
        # levels means it is a 2 deep hierarchy cause we can have lots of files
        # max_size limits the size of the cache
        proxy_cache_path /var/cache/nginx inactive=1440m levels=1:2 keys_zone=discourse:10m max_size=600m;

        # see: https://meta.discourse.org/t/x/74060
        proxy_buffer_size 8k;
      '';

      virtualHosts.${cfg.hostname} = {
        inherit (cfg) sslCertificate sslCertificateKey enableACME;
        forceSSL = lib.mkDefault tlsEnabled;

        root = "${cfg.package}/share/discourse/public";

        locations =
          let
            proxy = { extraConfig ? "" }: {
              proxyPass = "http://discourse";
              extraConfig = extraConfig + ''
                proxy_set_header X-Request-Start "t=''${msec}";
              '';
            };
            cache = time: ''
              expires ${time};
              add_header Cache-Control public,immutable;
            '';
            cache_1y = cache "1y";
            cache_1d = cache "1d";
          in
            {
              "/".tryFiles = "$uri @discourse";
              "@discourse" = proxy {};
              "^~ /backups/".extraConfig = ''
                internal;
              '';
              "/favicon.ico" = {
                return = "204";
                extraConfig = ''
                  access_log off;
                  log_not_found off;
                '';
              };
              "~ ^/uploads/short-url/" = proxy {};
              "~ ^/secure-media-uploads/" = proxy {};
              "~* (fonts|assets|plugins|uploads)/.*\.(eot|ttf|woff|woff2|ico|otf)$".extraConfig = cache_1y + ''
                add_header Access-Control-Allow-Origin *;
              '';
              "/srv/status" = proxy {
                extraConfig = ''
                  access_log off;
                  log_not_found off;
                '';
              };
              "~ ^/javascripts/".extraConfig = cache_1d;
              "~ ^/assets/(?<asset_path>.+)$".extraConfig = cache_1y + ''
                # asset pipeline enables this
                brotli_static on;
                gzip_static on;
              '';
              "~ ^/plugins/".extraConfig = cache_1y;
              "~ /images/emoji/".extraConfig = cache_1y;
              "~ ^/uploads/" = proxy {
                extraConfig = cache_1y + ''
                  proxy_set_header X-Sendfile-Type X-Accel-Redirect;
                  proxy_set_header X-Accel-Mapping ${cfg.package}/share/discourse/public/=/downloads/;

                  # custom CSS
                  location ~ /stylesheet-cache/ {
                      try_files $uri =404;
                  }
                  # this allows us to bypass rails
                  location ~* \.(gif|png|jpg|jpeg|bmp|tif|tiff|ico|webp)$ {
                      try_files $uri =404;
                  }
                  # SVG needs an extra header attached
                  location ~* \.(svg)$ {
                  }
                  # thumbnails & optimized images
                  location ~ /_?optimized/ {
                      try_files $uri =404;
                  }
                '';
              };
              "~ ^/admin/backups/" = proxy {
                extraConfig = ''
                  proxy_set_header X-Sendfile-Type X-Accel-Redirect;
                  proxy_set_header X-Accel-Mapping ${cfg.package}/share/discourse/public/=/downloads/;
                '';
              };
              "~ ^/(svg-sprite/|letter_avatar/|letter_avatar_proxy/|user_avatar|highlight-js|stylesheets|theme-javascripts|favicon/proxied|service-worker)" = proxy {
                extraConfig = ''
                  # if Set-Cookie is in the response nothing gets cached
                  # this is double bad cause we are not passing last modified in
                  proxy_ignore_headers "Set-Cookie";
                  proxy_hide_header "Set-Cookie";
                  proxy_hide_header "X-Discourse-Username";
                  proxy_hide_header "X-Runtime";

                  # note x-accel-redirect can not be used with proxy_cache
                  proxy_cache discourse;
                  proxy_cache_key "$scheme,$host,$request_uri";
                  proxy_cache_valid 200 301 302 7d;
                '';
              };
              "/message-bus/" = proxy {
                extraConfig = ''
                  proxy_http_version 1.1;
                  proxy_buffering off;
                '';
              };
              "/downloads/".extraConfig = ''
                internal;
                alias ${cfg.package}/share/discourse/public/;
              '';
            };
      };
    };

    systemd.services.discourse-mail-receiver-setup = lib.mkIf cfg.mail.incoming.enable (
      let
        mail-receiver-environment = {
          MAIL_DOMAIN = cfg.hostname;
          DISCOURSE_BASE_URL = "http${lib.optionalString tlsEnabled "s"}://${cfg.hostname}";
          DISCOURSE_API_KEY = "@api-key@";
          DISCOURSE_API_USERNAME = "system";
        };
        mail-receiver-json = json.generate "mail-receiver.json" mail-receiver-environment;
      in
        {
          before = [ "postfix.service" ];
          after = [ "discourse.service" ];
          wantedBy = [ "discourse.service" ];
          partOf = [ "discourse.service" ];
          path = [
            cfg.package.rake
            pkgs.jq
          ];
          preStart = lib.optionalString (cfg.mail.incoming.apiKeyFile == null) ''
            set -o errexit -o pipefail -o nounset -o errtrace
            shopt -s inherit_errexit

            if [[ ! -e /var/lib/discourse-mail-receiver/api_key ]]; then
                discourse-rake api_key:create_master[email-receiver] >/var/lib/discourse-mail-receiver/api_key
            fi
          '';
          script =
            let
              apiKeyPath =
                if cfg.mail.incoming.apiKeyFile == null then
                  "/var/lib/discourse-mail-receiver/api_key"
                else
                  cfg.mail.incoming.apiKeyFile;
            in ''
              set -o errexit -o pipefail -o nounset -o errtrace
              shopt -s inherit_errexit

              api_key=$(<'${apiKeyPath}')
              export api_key

              jq <${mail-receiver-json} \
                 '.DISCOURSE_API_KEY = $ENV.api_key' \
                 >'/run/discourse-mail-receiver/mail-receiver-environment.json'
            '';

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            RuntimeDirectory = "discourse-mail-receiver";
            RuntimeDirectoryMode = "0700";
            StateDirectory = "discourse-mail-receiver";
            User = "discourse";
            Group = "discourse";
          };
        });

    services.discourse.siteSettings = {
      required = {
        notification_email = cfg.mail.notificationEmailAddress;
        contact_email = cfg.mail.contactEmailAddress;
      };
      email = {
        manual_polling_enabled = cfg.mail.incoming.enable;
        reply_by_email_enabled = cfg.mail.incoming.enable;
        reply_by_email_address = cfg.mail.incoming.replyEmailAddress;
      };
    };

    services.postfix = lib.mkIf cfg.mail.incoming.enable {
      enable = true;
      sslCert = if cfg.sslCertificate != null then cfg.sslCertificate else "";
      sslKey = if cfg.sslCertificateKey != null then cfg.sslCertificateKey else "";

      origin = cfg.hostname;
      relayDomains = [ cfg.hostname ];
      config = {
        smtpd_recipient_restrictions = "check_policy_service unix:private/discourse-policy";
        append_dot_mydomain = lib.mkDefault false;
        compatibility_level = "2";
        smtputf8_enable = false;
        smtpd_banner = lib.mkDefault "ESMTP server";
        myhostname = lib.mkDefault cfg.hostname;
        mydestination = lib.mkDefault "localhost";
      };
      transport = ''
        ${cfg.hostname} discourse-mail-receiver:
      '';
      masterConfig = {
        "discourse-mail-receiver" = {
          type = "unix";
          privileged = true;
          chroot = false;
          command = "pipe";
          args = [
            "user=discourse"
            "argv=${cfg.mail.incoming.mailReceiverPackage}/bin/receive-mail"
            "\${recipient}"
          ];
        };
        "discourse-policy" = {
          type = "unix";
          privileged = true;
          chroot = false;
          command = "spawn";
          args = [
            "user=discourse"
            "argv=${cfg.mail.incoming.mailReceiverPackage}/bin/discourse-smtp-fast-rejection"
          ];
        };
      };
    };

    users.users = {
      discourse = {
        group = "discourse";
        isSystemUser = true;
      };
    } // (lib.optionalAttrs cfg.nginx.enable {
      ${config.services.nginx.user}.extraGroups = [ "discourse" ];
    });

    users.groups = {
      discourse = {};
    };

    environment.systemPackages = [
      cfg.package.rake
    ];
  };

  meta.doc = ./discourse.xml;
  meta.maintainers = [ lib.maintainers.talyz ];
}
