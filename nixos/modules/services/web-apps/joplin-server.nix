{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.joplin-server;

  # Format environment variables for Joplin Server
  envConfig = {
    APP_BASE_URL = cfg.baseUrl;
    APP_PORT = toString cfg.port;
    DB_CLIENT = if cfg.database.type == "postgres" then "pg" else "sqlite3";
    LOG_LEVEL = cfg.logLevel;
  }
  // optionalAttrs (cfg.database.type == "postgres") {
    POSTGRES_DATABASE = cfg.database.name;
    POSTGRES_USER = cfg.database.user;
    POSTGRES_HOST = cfg.database.host;
    POSTGRES_PORT = toString cfg.database.port;
  }
  // optionalAttrs (cfg.database.type == "sqlite") {
    SQLITE_DATABASE = cfg.database.sqlitePath;
  }
  // optionalAttrs cfg.mailer.enable {
    MAILER_ENABLED = "1";
    MAILER_HOST = cfg.mailer.host;
    MAILER_PORT = toString cfg.mailer.port;
    MAILER_SECURITY = cfg.mailer.security;
    MAILER_AUTH_USER = cfg.mailer.authUser;
    MAILER_NOREPLY_NAME = cfg.mailer.fromName;
    MAILER_NOREPLY_EMAIL = cfg.mailer.fromEmail;
  }
  // optionalAttrs (cfg.storage.driver == "Filesystem") {
    STORAGE_DRIVER = "Type=Filesystem; Path=${cfg.storage.path}";
  }
  // optionalAttrs (cfg.storage.driver == "Database") {
    STORAGE_DRIVER = "Type=Database";
  }
  // optionalAttrs (cfg.storage.driver == "S3") {
    STORAGE_DRIVER =
      "Type=S3; Bucket=${cfg.storage.s3.bucket}; Region=${cfg.storage.s3.region}"
      + optionalString (cfg.storage.s3.endpoint != null) "; Endpoint=${cfg.storage.s3.endpoint}"
      + optionalString (cfg.storage.s3.accessKey != null) "; AccessKeyId=${cfg.storage.s3.accessKey}";
  }
  // cfg.extraEnv;

  # Clean domain extractor helper
  domainFromUrl =
    url:
    builtins.head (
      lib.splitString ":" (builtins.replaceStrings [ "https://" "http://" ] [ "" "" ] url)
    );

  nginxHost = if cfg.nginx.hostName != null then cfg.nginx.hostName else (domainFromUrl cfg.baseUrl);
  caddyHost = if cfg.caddy.hostName != null then cfg.caddy.hostName else (domainFromUrl cfg.baseUrl);

in
{
  options.services.joplin-server = {
    enable = mkEnableOption "Joplin note synchronization server";

    package = mkOption {
      type = types.package;
      default = pkgs.joplin-server;
      defaultText = literalExpression "pkgs.joplin-server";
      description = "The Joplin Server package to use.";
    };

    useContainer = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to run Joplin Server inside an OCI container (Podman/Docker). Defaults to false (native Nix package).";
    };

    containerImage = mkOption {
      type = types.str;
      default = "docker.io/joplin/server:v3.2.1-beta";
      description = "OCI container image tag to use when useContainer is true.";
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Host IP address Joplin Server listens on.";
    };

    port = mkOption {
      type = types.port;
      default = 22300;
      description = "Port number Joplin Server listens on.";
    };

    baseUrl = mkOption {
      type = types.str;
      example = "https://joplin.example.com";
      description = "Public base URL where Joplin Server is accessible (required).";
    };

    logLevel = mkOption {
      type = types.enum [
        "trace"
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
      description = "Log verbosity level.";
    };

    user = mkOption {
      type = types.str;
      default = "joplin-server";
      description = "User account under which Joplin Server runs.";
    };

    group = mkOption {
      type = types.str;
      default = "joplin-server";
      description = "Group under which Joplin Server runs.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the service port in the NixOS firewall.";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/var/lib/joplin-server/secrets.env";
      description = ''
        Path to an environment file containing sensitive environment variables
        such as POSTGRES_PASSWORD, MAILER_AUTH_PASSWORD, or STORAGE_S3_SECRET_KEY.
      '';
    };

    extraEnv = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        MAX_UPLOAD_SIZE = "500mb";
      };
      description = "Additional environment variables passed to Joplin Server.";
    };

    database = {
      type = mkOption {
        type = types.enum [
          "postgres"
          "sqlite"
        ];
        default = "postgres";
        description = "Database backend engine.";
      };

      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically provision local PostgreSQL database and user.";
      };

      host = mkOption {
        type = types.str;
        default = "/run/postgresql";
        description = "Database server host or Unix socket directory.";
      };

      port = mkOption {
        type = types.port;
        default = 5432;
        description = "Database server port.";
      };

      name = mkOption {
        type = types.str;
        default = "joplin";
        description = "Database name.";
      };

      user = mkOption {
        type = types.str;
        default = "joplin";
        description = "Database user.";
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to file containing PostgreSQL password.";
      };

      sqlitePath = mkOption {
        type = types.path;
        default = "/var/lib/joplin-server/joplin.sqlite";
        description = "SQLite database file path (when type = 'sqlite').";
      };
    };

    storage = {
      driver = mkOption {
        type = types.enum [
          "Database"
          "Filesystem"
          "S3"
        ];
        default = "Database";
        description = "Storage driver for item attachments and revisions.";
      };

      path = mkOption {
        type = types.path;
        default = "/var/lib/joplin-server/data";
        description = "Directory for storage when driver is 'Filesystem'.";
      };

      s3 = {
        bucket = mkOption {
          type = types.str;
          default = "";
          description = "S3 bucket name.";
        };
        region = mkOption {
          type = types.str;
          default = "us-east-1";
          description = "S3 region.";
        };
        endpoint = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "S3 endpoint URL (for MinIO / custom S3).";
        };
        accessKey = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "S3 access key.";
        };
        secretKeyFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "Path to file containing S3 secret key.";
        };
      };
    };

    mailer = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable SMTP mailer toggle for account invitations and password resets.";
      };

      host = mkOption {
        type = types.str;
        default = "";
        description = "SMTP host address.";
      };

      port = mkOption {
        type = types.port;
        default = 587;
        description = "SMTP server port.";
      };

      security = mkOption {
        type = types.enum [
          "tls"
          "starttls"
          "none"
        ];
        default = "starttls";
        description = "SMTP connection security.";
      };

      authUser = mkOption {
        type = types.str;
        default = "";
        description = "SMTP authentication username.";
      };

      authPasswordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to file containing SMTP password.";
      };

      fromName = mkOption {
        type = types.str;
        default = "Joplin Server";
        description = "Sender display name for outgoing emails.";
      };

      fromEmail = mkOption {
        type = types.str;
        default = "";
        description = "Sender email address for outgoing emails.";
      };
    };

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Automatically configure Nginx reverse proxy virtual host.";
      };

      hostName = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Hostname for Nginx virtual host (defaults to domain from baseUrl).";
      };

      forceSSL = mkOption {
        type = types.bool;
        default = true;
        description = "Force SSL redirection in Nginx.";
      };

      enableACME = mkOption {
        type = types.bool;
        default = true;
        description = "Enable automatic Let's Encrypt SSL certificate via ACME.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional Nginx virtual host configuration directives.";
      };
    };

    caddy = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Automatically configure Caddy reverse proxy virtual host.";
      };

      hostName = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Hostname for Caddy virtual host (defaults to domain from baseUrl).";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional Caddy configuration directives.";
      };
    };

    systemdHardening = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable modern systemd security sandboxing flags.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.baseUrl != "";
        message = "services.joplin-server.baseUrl must be set (e.g., https://joplin.example.com).";
      }
      {
        assertion = !(cfg.nginx.enable && cfg.caddy.enable);
        message = "Only one reverse proxy toggle (Nginx or Caddy) can be enabled at a time.";
      }
      {
        assertion = cfg.mailer.enable -> (cfg.mailer.host != "" && cfg.mailer.fromEmail != "");
        message = "When services.joplin-server.mailer.enable is true, host and fromEmail must be set.";
      }
    ];

    # Firewall configuration toggle
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    # Local PostgreSQL database creation toggle
    services.postgresql = mkIf (cfg.database.type == "postgres" && cfg.database.createLocally) {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ]
      ++ optional (cfg.user != cfg.database.user) {
        name = cfg.user;
      };
      identMap = ''
        joplin-map ${cfg.user} ${cfg.database.user}
        joplin-map root ${cfg.database.user}
        joplin-map postgres ${cfg.database.user}
      '';
      authentication = mkOverride 10 ''
        local all all peer map=joplin-map
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
    };

    # System User / Group setup
    users.users.${cfg.user} = mkIf (cfg.user == "joplin-server") {
      isSystemUser = true;
      inherit (cfg) group;
      home = "/var/lib/joplin-server";
      createHome = true;
      description = "Joplin Server system user";
    };

    users.groups.${cfg.group} = mkIf (cfg.group == "joplin-server") { };

    # Systemd Service implementation for native process execution
    systemd.services.joplin-server = mkIf (!cfg.useContainer) {
      description = "Joplin Synchronization Server";
      after = [
        "network.target"
      ]
      ++ optional (cfg.database.type == "postgres" && cfg.database.createLocally) "postgresql.service";
      wants = optional (
        cfg.database.type == "postgres" && cfg.database.createLocally
      ) "postgresql.service";
      wantedBy = [ "multi-user.target" ];

      environment = envConfig;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/joplin-server";
        Restart = "on-failure";
        RestartSec = "10s";
        StateDirectory = "joplin-server";

        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
      }
      // optionalAttrs cfg.systemdHardening.enable {
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        CapabilityBoundingSet = "";
      };
    };

    # OCI Container implementation toggle
    virtualisation.oci-containers.containers.joplin-server = mkIf cfg.useContainer {
      image = cfg.containerImage;
      ports = [ "${cfg.host}:${toString cfg.port}:22300" ];
      environment = envConfig;
      environmentFiles = optional (cfg.environmentFile != null) cfg.environmentFile;
      volumes = optional (
        cfg.storage.driver == "Filesystem"
      ) "${cfg.storage.path}:/var/lib/joplin-server";
    };

    # Reverse Proxy Integration: Nginx
    services.nginx = mkIf cfg.nginx.enable {
      enable = true;
      virtualHosts.${nginxHost} = {
        forceSSL = cfg.nginx.forceSSL;
        enableACME = cfg.nginx.enableACME;
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 500M;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Port $server_port;
            ${cfg.nginx.extraConfig}
          '';
        };
      };
    };

    # Reverse Proxy Integration: Caddy
    services.caddy = mkIf cfg.caddy.enable {
      enable = true;
      virtualHosts.${caddyHost} = {
        extraConfig = ''
          reverse_proxy ${cfg.host}:${toString cfg.port}
          request_body {
            max_size 500MB
          }
          ${cfg.caddy.extraConfig}
        '';
      };
    };
  };
}
