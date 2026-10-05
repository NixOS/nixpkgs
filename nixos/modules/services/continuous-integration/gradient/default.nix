{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.gradient;
  env = cfg.environmentVariables;
  workerEnv = cfg.worker.environmentVariables;
  isTrue =
    value:
    lib.elem value [
      true
      "true"
    ];
  serverAddress = "http://${env.GRADIENT_LISTEN_ADDR}:${toString env.GRADIENT_PORT}";
  traceDir = env.GRADIENT_LOG_TRACE_DIR or null;

  jsonFormat = pkgs.formats.json { };

  stateKeyDefaults = {
    users = key: {
      username = key;
      name = key;
    };
    projects = key: {
      name = key;
      display_name = key;
      public = false;
    };
    tasks = key: {
      name = key;
      display_name = key;
    };
    integrations = key: { name = key; };
    caches = key: {
      name = key;
      display_name = key;
      public = false;
    };
    roles = key: { name = key; };
    api_keys = key: { name = key; };
    teams = key: {
      name = key;
      display_name = key;
    };
    workers = key: { display_name = key; };
  };

  state =
    builtins.removeAttrs cfg.state [ "validate" ]
    // lib.mapAttrs (
      collection: keyDefaults:
      lib.mapAttrs (key: entry: keyDefaults key // entry) (cfg.state.${collection} or { })
    ) stateKeyDefaults;

  stateJsonFile = jsonFormat.generate "gradient-state.json" state;

  validatedStateJsonFile =
    if cfg.state.validate then
      pkgs.runCommand "gradient-state-validated.json" { __structuredAttrs = true; } ''
        ${lib.getExe cfg.packages.server} --state-file ${stateJsonFile} --state-validate
        cp ${stateJsonFile} $out
      ''
    else
      stateJsonFile;

  secretVariables = {
    jwtFile = "GRADIENT_SECRETS_JWT_FILE";
    cryptFile = "GRADIENT_SECRETS_CRYPT_FILE";
    databaseUrlFile = "GRADIENT_DATABASE_URL_FILE";
    oidcClientSecretFile = "GRADIENT_OIDC_CLIENT_SECRET_FILE";
    scimTokenFile = "GRADIENT_SCIM_TOKEN_FILE";
    smtpPasswordFile = "GRADIENT_EMAIL_SMTP_PASSWORD_FILE";
    s3SecretAccessKeyFile = "GRADIENT_S3_SECRET_ACCESS_KEY_FILE";
    githubAppPrivateKeyFile = "GRADIENT_GITHUB_APP_PRIVATE_KEY_FILE";
    githubAppWebhookSecretFile = "GRADIENT_GITHUB_APP_WEBHOOK_SECRET_FILE";
    sshHostKeyFile = "GRADIENT_SSH_HOST_KEY_FILE";
    metricsTokenFile = "GRADIENT_METRICS_TOKEN_FILE";
  };

  secretFiles = lib.filterAttrs (_: file: file != null) cfg.secrets;

  actionSecretFields = {
    send_web_request = "token";
    send_matrix_message = "access_token";
    send_slack_message = "webhook_url";
  };

  stateCredentials = lib.concatLists (
    lib.mapAttrsToList (
      _: user:
      lib.optional (
        user.password_file or null != null
      ) "gradient_user_${user.username}_password:${user.password_file}"
    ) state.users
    ++ lib.mapAttrsToList (_: project: [
      "gradient_project_${project.name}_private_key:${project.private_key_file}"
    ]) state.projects
    ++ lib.mapAttrsToList (_: cache: [
      "gradient_cache_${cache.name}_signing_key:${cache.signing_key_file}"
    ]) state.caches
    ++ lib.mapAttrsToList (_: apiKey: [
      "gradient_api_${apiKey.name}_key:${apiKey.key_file}"
    ]) state.api_keys
    ++ lib.mapAttrsToList (_: worker: [
      "gradient_worker_${worker.worker_id}_token:${worker.token_file}"
    ]) state.workers
    ++ lib.mapAttrsToList (
      _: int:
      lib.optional (
        int.secret_file or null != null
      ) "gradient_integration_${int.name}_secret:${int.secret_file}"
      ++ lib.optional (
        int.access_token_file or null != null
      ) "gradient_integration_${int.name}_token:${int.access_token_file}"
    ) state.integrations
    ++ lib.mapAttrsToList (
      _: task:
      lib.concatMap (
        action:
        let
          field = actionSecretFields.${action.type} or null;
          file = if field == null then null else action.config."${field}_file" or null;
        in
        lib.optional (file != null) "gradient_action_${action.name}_${field}:${file}"
      ) (task.actions or [ ])
    ) state.tasks
  );

  localWorker = cfg.worker.enable && cfg.localWorker;

  identityHash = builtins.hashString "sha256" "gradient-local-worker:${config.networking.hostName}";
  localIdentity = lib.concatStringsSep "-" [
    (builtins.substring 0 8 identityHash)
    (builtins.substring 8 4 identityHash)
    (builtins.substring 12 4 identityHash)
    (builtins.substring 16 4 identityHash)
    (builtins.substring 20 12 identityHash)
  ];

  localTokenFile = "${workerEnv.GRADIENT_WORKER_BASE_DIR}/local-token";
  localPeersFile = "${workerEnv.GRADIENT_WORKER_BASE_DIR}/local-peers";
in
{
  meta.teams = [ lib.teams.gradient ];

  options.services.gradient = {
    enable = lib.mkEnableOption "Gradient";

    packages = {
      server = lib.mkPackageOption pkgs "gradient" { };
      frontend = lib.mkPackageOption pkgs "gradient-frontend" { };
    };

    domain = lib.mkOption {
      type = lib.types.str;
      example = "gradient.example.com";
      description = "Domain under which Gradient is reachable.";
    };

    environmentVariables = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.nullOr (
          lib.types.oneOf [
            lib.types.bool
            lib.types.int
            lib.types.str
            lib.types.path
          ]
        )
      );
      default = { };
      example = {
        GRADIENT_OIDC_ENABLE = true;
        GRADIENT_OIDC_CLIENT_ID = "gradient";
        GRADIENT_OIDC_DISCOVERY_URL = "https://id.example.com/.well-known/openid-configuration";
        GRADIENT_GC_INTERVAL_SECS = 600;
      };
      description = ''
        Environment variables of the Gradient server. The
        [configuration reference](https://github.com/wavelens/gradient) lists every variable and
        its default. `null` unsets a variable. Secrets belong in
        {option}`services.gradient.secrets`.
      '';
    };

    secrets =
      lib.mapAttrs (
        _: variable:
        lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            File containing the secret behind {env}`${variable}`, loaded as a systemd credential.
          '';
        }
      ) secretVariables
      // {
        jwtFile = lib.mkOption {
          type = lib.types.path;
          description = "File containing the secret used to sign JWTs.";
        };

        cryptFile = lib.mkOption {
          type = lib.types.path;
          description = "File containing the key used to encrypt secrets in the database.";
        };
      };

    state = lib.mkOption {
      type = lib.types.submodule {
        freeformType = jsonFormat.type;
        options.validate = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to check the state with the server's `--state-validate` at build time.
            Schema and reference errors then fail the Nix build instead of the server start.
          '';
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          users.alice = {
            email = "alice@example.com";
            password_file = "/etc/gradient/secrets/alice_password";
            superuser = true;
          };
          projects.acme-corp = {
            private_key_file = "/etc/gradient/secrets/acme_ssh_key";
            created_by = "alice";
          };
          tasks.web-app = {
            project = "acme-corp";
            repository = "https://github.com/acme-corp/web-app.git";
            wildcard = "nixosConfigurations.*.config.system.build.toplevel";
            created_by = "alice";
            triggers = [
              {
                type = "polling";
                config.interval_secs = 300;
              }
            ];
          };
          caches.main-cache = {
            signing_key_file = "/etc/gradient/secrets/main_cache_key";
            projects = [ "acme-corp" ];
            created_by = "alice";
          };
        }
      '';
      description = ''
        Declarative Gradient state, written as JSON to the server's state file. The
        [Gradient repository](https://github.com/wavelens/gradient) documents the available fields.
        Fields naming an entry, such as `name`, `username` and `display_name`, default to its
        attribute name. Files in `password_file`, `private_key_file`, `signing_key_file`, `key_file`,
        `token_file`, `secret_file`, `access_token_file` and the secret files of task actions become
        systemd credentials of the server.
      '';
    };

    localWorker = lib.mkOption {
      type = lib.types.bool;
      default = cfg.worker.enable;
      defaultText = lib.literalExpression "config.services.gradient.worker.enable";
      description = ''
        Whether to register the {option}`services.gradient.worker` on this host automatically,
        with an ID from the hostname and a token and peers file from the first start. Members of
        the state-declared team `server` reach every new project, the local worker included.
      '';
    };

    nginx = {
      enable = lib.mkEnableOption "an nginx virtual host for Gradient" // {
        default = true;
      };

      manageTls = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to let nginx obtain and present the TLS certificate through the virtual host's
          `enableACME` and `forceSSL`. Disable it behind a proxy terminating TLS itself. It has no
          effect with {env}`GRADIENT_USE_TLS` set to `false`.
        '';
      };

      frontend = lib.mkEnableOption "serving the Gradient web frontend" // {
        default = true;
      };

      exposeProto = lib.mkEnableOption "`/proto` for remote workers and federation";
    };

    postgres.enable = lib.mkEnableOption "a local PostgreSQL database for Gradient";
  };

  config = lib.mkIf cfg.enable {
    services.gradient = {
      environmentVariables = lib.mapAttrs (_: lib.mkDefault) {
        GRADIENT_LISTEN_ADDR = "127.0.0.1";
        GRADIENT_PORT = 3000;
        GRADIENT_USE_TLS = true;
        GRADIENT_BASE_DIR = "/var/lib/gradient";
        GRADIENT_SERVE_URL = "http${lib.optionalString (isTrue env.GRADIENT_USE_TLS) "s"}://${cfg.domain}";
        GRADIENT_FRONTEND_URL = env.GRADIENT_SERVE_URL;
        GRADIENT_DATABASE_URL = "postgresql://gradient@localhost/gradient?host=/run/postgresql";
      };

      state = lib.mkIf localWorker {
        teams.server = {
          display_name = "Server";
          new_projects.workers = true;
        };

        workers.local = {
          display_name = "Local Worker";
          worker_id = localIdentity;
          token_file = localTokenFile;
          team = "server";
        };
      };

      worker = lib.mkIf localWorker {
        peersFile = lib.mkDefault localPeersFile;
        environmentVariables = lib.mapAttrs (_: lib.mkDefault) {
          GRADIENT_WORKER_ID = localIdentity;
          GRADIENT_WORKER_SERVER_URL = "ws://127.0.0.1:${toString env.GRADIENT_PORT}/proto";
        };
      };
    };

    assertions = [
      {
        assertion = cfg.localWorker -> cfg.worker.enable;
        message = "Enable services.gradient.worker for services.gradient.localWorker.";
      }
    ];

    systemd.services.gradient-local-worker-token = lib.mkIf localWorker {
      description = "Gradient local worker credentials";
      requiredBy = [ "gradient-worker.service" ];
      before = [ "gradient-worker.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "gradient-worker";
        Group = "gradient-worker";
        StateDirectory = "gradient-worker";
        UMask = "0077";
      };

      script = ''
        if [ ! -s ${localTokenFile} ]; then
          ${lib.getExe pkgs.openssl} rand -base64 48 > ${localTokenFile}.new
          mv ${localTokenFile}.new ${localTokenFile}
        fi
        printf '*:%s\n' "$(cat ${localTokenFile})" > ${localPeersFile}.new
        mv ${localPeersFile}.new ${localPeersFile}
        chmod 0400 ${localTokenFile} ${localPeersFile}
      '';
    };

    systemd.tmpfiles.settings."10-gradient-trace" = lib.mkIf (traceDir != null) {
      ${traceDir}.d = {
        user = "gradient";
        group = "gradient";
        mode = "0750";
      };
    };

    systemd.services.gradient-server = {
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "systemd-tmpfiles-setup.service"
      ]
      ++ lib.optional cfg.postgres.enable "postgresql.target"
      ++ lib.optional localWorker "gradient-local-worker-token.service";
      requires = lib.optional localWorker "gradient-local-worker-token.service";

      serviceConfig = {
        Type = "notify";
        ExecStart = lib.getExe cfg.packages.server;
        TimeoutStartSec = "infinity";
        StateDirectory = "gradient";
        User = "gradient";
        Group = "gradient";
        PrivateTmp = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = [ env.GRADIENT_BASE_DIR ] ++ lib.optional (traceDir != null) traceDir;
        Restart = "on-failure";
        RestartSec = 10;
        LimitNOFILE = 65535;
        # Secrets are mlock'd to keep them off swap. The lock is failing with EPERM below this limit
        # and flooding the log on every SSH-key git operation.
        LimitMEMLOCK = "128M";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        WorkingDirectory = env.GRADIENT_BASE_DIR;
        LoadCredential = [
          "gradient_state:${validatedStateJsonFile}"
        ]
        ++ lib.mapAttrsToList (name: file: "gradient_${name}:${file}") secretFiles
        ++ stateCredentials;
      };

      unitConfig = {
        StartLimitIntervalSec = 60;
        StartLimitBurst = 5;
      };

      environment =
        lib.mapAttrs (
          _: value: if lib.isBool value then lib.boolToString value else lib.mapNullable toString value
        ) env
        // lib.mapAttrs' (
          name: _: lib.nameValuePair secretVariables.${name} "%d/gradient_${name}"
        ) secretFiles
        // {
          NIX_REMOTE = "daemon";
          XDG_CACHE_HOME = "${env.GRADIENT_BASE_DIR}/www/.cache";
          GRADIENT_STATE_FILE = "%d/gradient_state";
          GRADIENT_CREDENTIALS_DIR = "%d";
        };
    };

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      virtualHosts.${cfg.domain} = {
        enableACME = isTrue env.GRADIENT_USE_TLS && cfg.nginx.manageTls;
        forceSSL = isTrue env.GRADIENT_USE_TLS && cfg.nginx.manageTls;
        http2 = true;
        http3 = isTrue (env.GRADIENT_USE_QUIC or false);
        locations = {
          "/" = lib.mkIf cfg.nginx.frontend {
            root = "${cfg.packages.frontend}/share/gradient-frontend";
            tryFiles = "$uri $uri/ /index.html";
          };

          "/api/" = {
            proxyPass = serverAddress;
            proxyWebsockets = true;
            extraConfig = ''
              client_max_body_size 0;
              proxy_buffering off;
              proxy_request_buffering off;
              proxy_connect_timeout 1h;
              proxy_send_timeout 1h;
              proxy_read_timeout 1h;
            '';
          };

          "/proto" = lib.mkIf cfg.nginx.exposeProto {
            proxyPass = serverAddress;
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffer_size 256k;
              proxy_buffers 4 256k;
              proxy_connect_timeout 90d;
              proxy_send_timeout 90d;
              proxy_read_timeout 90d;
            '';
          };

          "~ ^/cache/[^/]+/proto$" = {
            proxyPass = serverAddress;
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffer_size 256k;
              proxy_buffers 4 256k;
              proxy_connect_timeout 1h;
              proxy_send_timeout 1h;
              proxy_read_timeout 1h;
            '';
          };

          "/cache/" = {
            proxyPass = serverAddress;
            proxyWebsockets = true;
            extraConfig = ''
              client_max_body_size 0;
              proxy_buffering off;
              proxy_request_buffering off;
              proxy_connect_timeout 1h;
              proxy_send_timeout 1h;
              proxy_read_timeout 1h;
            '';
          };
        };
      };
    };

    services.postgresql = lib.mkIf cfg.postgres.enable {
      enable = true;
      ensureDatabases = [ "gradient" ];
      ensureUsers = [
        {
          name = "gradient";
          ensureDBOwnership = true;
        }
      ];
      settings = {
        max_connections = lib.mkDefault 200;
        max_locks_per_transaction = lib.mkDefault 1024;
      };
    };

    users = {
      groups.gradient = { };
      users.gradient = {
        description = "Gradient user";
        isSystemUser = true;
        home = env.GRADIENT_BASE_DIR;
        createHome = true;
        group = "gradient";
      };
    };
  };
}
