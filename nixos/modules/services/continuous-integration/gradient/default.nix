{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.gradient;

  stateJsonFile = pkgs.writers.writeJSON "gradient-state.json" cfg.state;
  userPasswordFiles = map (
    user: "gradient_user_${user.username}_password:${user.password_file}"
  ) cfg.state.users;
  orgPrivateKeyFiles = map (
    org: "gradient_org_${org.name}_private_key:${org.private_key_file}"
  ) cfg.state.organizations;
  cacheSigningKeyFiles = map (
    cache: "gradient_cache_${cache.name}_signing_key:${cache.signing_key_file}"
  ) cfg.state.caches;
  apiKeyFiles = map (
    api_key: "gradient_api_${api_key.name}_key:${api_key.key_file}"
  ) cfg.state.api_keys;
in
{
  options = {
    services.gradient = {
      enable = lib.mkEnableOption "Gradient";
      configureNginx = lib.mkEnableOption "Nginx configuration";
      configurePostgres = lib.mkEnableOption "PostgreSQL configuration";
      serveCache = lib.mkEnableOption "cache serving";
      reportErrors = lib.mkEnableOption "error reporting to Sentry";
      useTls = lib.mkEnableOption "TLS" // {
        default = true;
      };
      packages = {
        server = lib.mkPackageOption pkgs "gradient-server" { };
        frontend = lib.mkPackageOption pkgs "gradient-frontend" { };
        nix = lib.mkOption {
          default = config.nix.package;
          defaultText = lib.literalExpression "config.nix.package";
          type = lib.types.package;
          description = "Nix package to use";
        };

        ssh = lib.mkOption {
          default = config.programs.ssh.package;
          defaultText = lib.literalExpression "config.programs.ssh.package";
          type = lib.types.package;
          description = "OpenSSH package to use";
        };

        git = lib.mkOption {
          default = config.programs.git.package;
          defaultText = lib.literalExpression "config.programs.git.package";
          type = lib.types.package;
          description = "Git package to use (required by Nix when fetching git+https:// flake inputs)";
        };
      };

      domain = lib.mkOption {
        description = "Domain under which Gradient is being served.";
        type = lib.types.str;
        example = "gradient.example.com";
      };

      baseDir = lib.mkOption {
        description = "Base directory for Gradient.";
        type = lib.types.path;
        default = "/var/lib/gradient";
      };

      listenAddr = lib.mkOption {
        description = "IP address on which Gradient listens.";
        type = lib.types.str;
        default = "127.0.0.1";
      };

      port = lib.mkOption {
        description = "Port on which Gradient listens.";
        type = lib.types.port;
        default = 3000;
      };

      jwtSecretFile = lib.mkOption {
        description = "Secret key file used to sign JWTs.";
        type = lib.types.path;
      };

      cryptSecretFile = lib.mkOption {
        description = "Database encryption password file.";
        type = lib.types.path;
      };

      databaseUrl = lib.mkOption {
        description = "URL of the database to use.";
        type = lib.types.str;
        default = "postgresql://localhost/gradient?host=/run/postgresql";
      };

      databaseUrlFile = lib.mkOption {
        description = "URL-file of the database to use.";
        type = lib.types.path;
        default = pkgs.writeText "database_url" cfg.databaseUrl;
        defaultText = lib.literalExpression "pkgs.writeText \"database_url\" config.services.gradient.databaseUrl;";
        example = "/etc/gradient/database_url";
      };

      frontend = {
        enable = lib.mkEnableOption "Gradient Frontend";
      };

      oidc = {
        enable = lib.mkEnableOption "OIDC";
        required = lib.mkEnableOption "OIDC requirement for registration.";
        clientId = lib.mkOption {
          description = "Client ID for OIDC.";
          type = lib.types.str;
        };

        clientSecretFile = lib.mkOption {
          description = "Client secret file for OIDC.";
          type = lib.types.path;
        };

        scopes = lib.mkOption {
          description = "Scopes for OIDC.";
          type = lib.types.listOf lib.types.str;
          default = [
            "openid"
            "email"
            "profile"
          ];
        };

        discoveryUrl = lib.mkOption {
          description = "Discovery URL for OIDC.";
          type = lib.types.str;
        };

        iconUrl = lib.mkOption {
          description = "Icon URL for OIDC provider.";
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };

      email = {
        enable = lib.mkEnableOption "email functionality";
        requireVerification = lib.mkEnableOption "email verification requirement for registrations";
        enableTls = lib.mkEnableOption "TLS for SMTP connections";
        smtpHost = lib.mkOption {
          description = "SMTP server hostname";
          type = lib.types.str;
        };

        smtpPort = lib.mkOption {
          description = "SMTP server port";
          type = lib.types.port;
          default = 587;
        };

        smtpUsername = lib.mkOption {
          description = "SMTP username";
          type = lib.types.str;
        };

        smtpPasswordFile = lib.mkOption {
          description = "File containing SMTP password";
          type = lib.types.path;
        };

        fromAddress = lib.mkOption {
          description = "Email address to send from";
          type = lib.types.str;
        };

        fromName = lib.mkOption {
          description = "Name to display in email from field";
          type = lib.types.str;
          default = "Gradient";
        };
      };

      settings = {
        enableRegistration = lib.mkEnableOption "registration. Users must be registered via OIDC." // {
          default = true;
        };
        maxConcurrentEvaluations = lib.mkOption {
          description = "Maximum number of concurrent evaluations.";
          type = lib.types.ints.positive;
          default = 1;
        };

        maxConcurrentBuilds = lib.mkOption {
          description = "Maximum number of concurrent builds.";
          type = lib.types.ints.positive;
          default = 100;
        };

        keepEvaluations = lib.mkOption {
          description = "Amount of evaluations to keep in the database and cache.";
          type = lib.types.ints.positive;
          default = 5;
        };

        maxNixdaemonConnections = lib.mkOption {
          description = "Maximum number of simultaneous local Nix daemon connections in the connection pool.";
          type = lib.types.ints.positive;
          default = 24;
        };

        logLevel = lib.mkOption {
          description = "Log level for the application.";
          type = lib.types.enum [
            "trace"
            "debug"
            "info"
            "warn"
            "error"
          ];
          default = "info";
        };

        deleteState = lib.mkOption {
          description = "Delete all state (users, organizations, caches) if not manged anymore by state.";
          type = lib.types.bool;
          default = true;
        };

        cacheTtlHours = lib.mkOption {
          description = "TTL in hours for non-entry-point cached NAR files. 0 disables GC.";
          type = lib.types.ints.positive;
          default = 336;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      tmpfiles.settings."10-gradient"."/nix/var/nix/gcroots/gradient".d = {
        user = "gradient";
        group = "gradient";
        mode = "0755";
      };

      services.gradient-server = {
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "postgresql.target"
          "systemd-tmpfiles-setup.service"
        ];

        path = [
          cfg.packages.nix
          cfg.packages.ssh
          cfg.packages.git
        ];

        serviceConfig = {
          ExecStart = lib.getExe cfg.packages.server;
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
          ReadWritePaths = [ "/nix/var/nix/gcroots/gradient" ];
          Restart = "on-failure";
          RestartSec = 10;
          LimitNOFILE = 65535;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          WorkingDirectory = cfg.baseDir;
          LoadCredential = [
            "gradient_database_url:${cfg.databaseUrlFile}"
            "gradient_crypt_secret:${cfg.cryptSecretFile}"
            "gradient_jwt_secret:${cfg.jwtSecretFile}"
            "gradient_state:${stateJsonFile}"
          ]
          ++ lib.optional cfg.oidc.enable [
            "gradient_oidc_client_secret:${cfg.oidc.clientSecretFile}"
          ]
          ++ lib.optional cfg.email.enable [
            "gradient_email_smtp_password:${cfg.email.smtpPasswordFile}"
          ]
          ++ userPasswordFiles
          ++ orgPrivateKeyFiles
          ++ cacheSigningKeyFiles
          ++ apiKeyFiles;
        };

        environment = {
          NIX_REMOTE = "daemon";
          XDG_CACHE_HOME = "${cfg.baseDir}/www/.cache";
          GRADIENT_IP = cfg.listenAddr;
          GRADIENT_PORT = toString cfg.port;
          GRADIENT_SERVE_URL = "http${lib.optionalString cfg.useTls "s"}://${cfg.domain}";
          GRADIENT_BASE_PATH = cfg.baseDir;
          GRADIENT_DATABASE_URL_FILE = "%d/gradient_database_url";
          GRADIENT_MAX_CONCURRENT_EVALUATIONS = toString cfg.settings.maxConcurrentEvaluations;
          GRADIENT_MAX_CONCURRENT_BUILDS = toString cfg.settings.maxConcurrentBuilds;
          GRADIENT_BINPATH_NIX = lib.getExe cfg.packages.nix;
          GRADIENT_BINPATH_SSH = lib.getExe' cfg.packages.ssh "ssh";
          GRADIENT_OIDC_ENABLED = lib.boolToString cfg.oidc.enable;
          GRADIENT_ENABLE_REGISTRATION = lib.boolToString cfg.settings.enableRegistration;
          GRADIENT_CRYPT_SECRET_FILE = "%d/gradient_crypt_secret";
          GRADIENT_JWT_SECRET_FILE = "%d/gradient_jwt_secret";
          GRADIENT_SERVE_CACHE = lib.boolToString cfg.serveCache;
          GRADIENT_REPORT_ERRORS = lib.boolToString cfg.reportErrors;
          GRADIENT_KEEP_EVALUATIONS = toString cfg.settings.keepEvaluations;
          GRADIENT_MAX_NIXDAEMON_CONNECTIONS = toString cfg.settings.maxNixdaemonConnections;
          GRADIENT_LOG_LEVEL = cfg.settings.logLevel;
          GRADIENT_DELETE_STATE = lib.boolToString cfg.settings.deleteState;
          GRADIENT_NAR_TTL_HOURS = toString cfg.settings.cacheTtlHours;
          GRADIENT_STATE_FILE = "%d/gradient_state";
          GRADIENT_CREDENTIALS_DIR = "%d";
          RUST_LOG = cfg.settings.logLevel;
        }
        // lib.optionalAttrs cfg.oidc.enable {
          GRADIENT_OIDC_CLIENT_ID = cfg.oidc.clientId;
          GRADIENT_OIDC_CLIENT_SECRET_FILE = "%d/gradient_oidc_client_secret";
          GRADIENT_OIDC_SCOPES = builtins.concatStringsSep " " cfg.oidc.scopes;
          GRADIENT_OIDC_DISCOVERY_URL = cfg.oidc.discoveryUrl;
          GRADIENT_OIDC_REQUIRED = lib.boolToString cfg.oidc.required;
        }
        // lib.optionalAttrs cfg.email.enable {
          GRADIENT_EMAIL_ENABLED = lib.boolToString cfg.email.enable;
          GRADIENT_EMAIL_REQUIRE_VERIFICATION = lib.boolToString cfg.email.requireVerification;
          GRADIENT_EMAIL_SMTP_HOST = cfg.email.smtpHost;
          GRADIENT_EMAIL_SMTP_PORT = toString cfg.email.smtpPort;
          GRADIENT_EMAIL_SMTP_USERNAME = cfg.email.smtpUsername;
          GRADIENT_EMAIL_SMTP_PASSWORD_FILE = "%d/gradient_email_smtp_password";
          GRADIENT_EMAIL_FROM_ADDRESS = cfg.email.fromAddress;
          GRADIENT_EMAIL_FROM_NAME = cfg.email.fromName;
          GRADIENT_EMAIL_ENABLE_TLS = lib.boolToString cfg.email.enableTls;
        };
      };
    };

    nix.settings = {
      trusted-users = [ "gradient" ];
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
    };

    services = {
      nginx = lib.mkIf cfg.configureNginx {
        enable = true;
        virtualHosts."${cfg.domain}" = {
          enableACME = true;
          forceSSL = true;
          http2 = true;
          locations = {
            "/" = lib.mkIf cfg.frontend.enable {
              root = "${cfg.packages.frontend}/share/gradient-frontend";
              tryFiles = "$uri $uri/ /index.html";
            };

            "/api/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.gradient.port}";
              proxyWebsockets = true;
            };

            "/cache/" = lib.mkIf cfg.serveCache {
              proxyPass = "http://127.0.0.1:${toString config.services.gradient.port}";
              proxyWebsockets = true;
            };
          };
        };
      };

      postgresql = lib.mkIf cfg.configurePostgres {
        enable = true;
        ensureDatabases = [ "gradient" ];
        ensureUsers = [
          {
            name = "gradient";
            ensureDBOwnership = true;
          }
        ];
      };
    };

    users = {
      groups.gradient = { };
      users.gradient = {
        description = "Gradient user";
        isSystemUser = true;
        home = cfg.baseDir;
        createHome = true;
        group = "gradient";
      };
    };
  };
}
