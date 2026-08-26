{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.oxicloud;

  defaultUser = "oxicloud";
  defaultGroup = "oxicloud";

  extraEnvironment = lib.mapAttrs (
    _: v: if builtins.isBool v then lib.boolToString v else toString v
  ) (lib.filterAttrs (_: v: v != null) cfg.settings.extraEnvironment);

  env = {
    OXICLOUD_STORAGE_PATH = cfg.settings.storagePath;
    OXICLOUD_SERVER_PORT = toString cfg.settings.port;
    OXICLOUD_SERVER_HOST = cfg.settings.host;
    OXICLOUD_BASE_URL = cfg.settings.baseUrl;

    OXICLOUD_DB_MAX_CONNECTIONS = toString cfg.settings.database.maxConnections;
    OXICLOUD_DB_MIN_CONNECTIONS = toString cfg.settings.database.minConnections;
    OXICLOUD_DB_MAINTENANCE_MAX_CONNECTIONS = toString cfg.settings.database.maintenanceMaxConnections;
    OXICLOUD_DB_MAINTENANCE_MIN_CONNECTIONS = toString cfg.settings.database.maintenanceMinConnections;

    OXICLOUD_ENABLE_AUTH = lib.boolToString cfg.settings.auth.enable;
    OXICLOUD_ACCESS_TOKEN_EXPIRY_SECS = toString cfg.settings.auth.accessTokenExpirySecs;
    OXICLOUD_REFRESH_TOKEN_EXPIRY_SECS = toString cfg.settings.auth.refreshTokenExpirySecs;

    OXICLOUD_ENABLE_USER_STORAGE_QUOTAS = lib.boolToString cfg.settings.features.userStorageQuotas;
    OXICLOUD_ENABLE_FILE_SHARING = lib.boolToString cfg.settings.features.fileSharing;
    OXICLOUD_ENABLE_TRASH = lib.boolToString cfg.settings.features.trash;
    OXICLOUD_ENABLE_SEARCH = lib.boolToString cfg.settings.features.search;

    OXICLOUD_OIDC_ENABLED = lib.boolToString cfg.settings.oidc.enable;
    OXICLOUD_OIDC_SCOPES = lib.concatStringsSep " " cfg.settings.oidc.scopes;
    OXICLOUD_OIDC_AUTO_PROVISION = lib.boolToString cfg.settings.oidc.autoProvision;
    OXICLOUD_OIDC_ADMIN_GROUPS = lib.concatStringsSep "," cfg.settings.oidc.adminGroups;
    OXICLOUD_OIDC_DISABLE_PASSWORD_LOGIN = lib.boolToString cfg.settings.oidc.disablePasswordLogin;
    OXICLOUD_OIDC_PROVIDER_NAME = cfg.settings.oidc.providerName;

    OXICLOUD_WOPI_ENABLED = lib.boolToString cfg.settings.wopi.enable;
    OXICLOUD_WOPI_TOKEN_TTL_SECS = toString cfg.settings.wopi.tokenTtlSecs;
    OXICLOUD_WOPI_LOCK_TTL_SECS = toString cfg.settings.wopi.lockTtlSecs;

    MIMALLOC_PURGE_DELAY = toString cfg.settings.mimalloc.purgeDelay;
    MIMALLOC_ALLOW_LARGE_OS_PAGES = if cfg.settings.mimalloc.allowLargeOsPages then "1" else "0";
  }
  // lib.optionalAttrs (cfg.settings.staticPath != null) {
    OXICLOUD_STATIC_PATH = cfg.settings.staticPath;
  }
  // lib.optionalAttrs (cfg.settings.database.url != null) {
    OXICLOUD_DB_CONNECTION_STRING = cfg.settings.database.url;
  }
  // lib.optionalAttrs (cfg.settings.oidc.issuerUrl != null) {
    OXICLOUD_OIDC_ISSUER_URL = cfg.settings.oidc.issuerUrl;
  }
  // lib.optionalAttrs (cfg.settings.oidc.clientId != null) {
    OXICLOUD_OIDC_CLIENT_ID = cfg.settings.oidc.clientId;
  }
  // lib.optionalAttrs (cfg.settings.oidc.clientSecret != null) {
    OXICLOUD_OIDC_CLIENT_SECRET = cfg.settings.oidc.clientSecret;
  }
  // lib.optionalAttrs (cfg.settings.oidc.redirectUri != null) {
    OXICLOUD_OIDC_REDIRECT_URI = cfg.settings.oidc.redirectUri;
  }
  // lib.optionalAttrs (cfg.settings.oidc.frontendUrl != null) {
    OXICLOUD_OIDC_FRONTEND_URL = cfg.settings.oidc.frontendUrl;
  }
  // lib.optionalAttrs (cfg.settings.wopi.discoveryUrl != null) {
    OXICLOUD_WOPI_DISCOVERY_URL = cfg.settings.wopi.discoveryUrl;
  }
  // lib.optionalAttrs (cfg.settings.auth.jwtSecret != null) {
    OXICLOUD_JWT_SECRET = cfg.settings.auth.jwtSecret;
  }
  // lib.optionalAttrs (cfg.settings.wopi.secret != null) {
    OXICLOUD_WOPI_SECRET = cfg.settings.wopi.secret;
  }
  // extraEnvironment;
in
{
  options.services.oxicloud = {
    enable = lib.mkEnableOption "OxiCloud";

    package = lib.mkPackageOption pkgs "oxicloud" { };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/oxicloud";
      description = "Directory where OxiCloud stores service data.";
    };

    createDataDir = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to create {option}`services.oxicloud.dataDir`.";
    };

    createLocalDatabase = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to create a local PostgreSQL database and role for OxiCloud.";
    };

    openFirewall = lib.mkEnableOption "opening the OxiCloud port in the firewall";

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = "User account under which OxiCloud runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = defaultGroup;
      description = "Group under which OxiCloud runs.";
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "/run/secrets/oxicloud.env" ];
      description = ''
        Additional environment files to load, typically for secrets such as
        {env}`OXICLOUD_DB_CONNECTION_STRING`, {env}`OXICLOUD_JWT_SECRET`,
        {env}`OXICLOUD_OIDC_CLIENT_SECRET`, or {env}`OXICLOUD_WOPI_SECRET`.

        When the same variable is set both via module options and an environment
        file, the value from the environment file takes precedence.
      '';
    };

    settings = {
      storagePath = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.dataDir}/storage";
        defaultText = lib.literalExpression ''"''${config.services.oxicloud.dataDir}/storage"'';
        description = "Path for file storage.";
      };

      staticPath = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Path to static files directory.

          Leave unset to use the packaged assets from {option}`services.oxicloud.package`.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8086;
        description = "Server port.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Server bind address.";
      };

      baseUrl = lib.mkOption {
        type = lib.types.str;
        default = "http://${cfg.settings.host}:${toString cfg.settings.port}";
        defaultText = lib.literalExpression ''
          "http://''${config.services.oxicloud.settings.host}:''${toString config.services.oxicloud.settings.port}"
        '';
        description = ''
          Public base URL for generating share links and external URLs.

          Defaults to http://{OXICLOUD_SERVER_HOST}:{OXICLOUD_SERVER_PORT}.
        '';
      };

      database = {
        url = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "postgres:///oxicloud?host=/run/postgresql";
          example = lib.literalExpression ''"postgres://user:password@localhost:5432/oxicloud"'';
          description = ''
            PostgreSQL connection string.

            If using a password, prefer setting this via {option}`services.oxicloud.environmentFiles`.
          '';
        };

        maxConnections = lib.mkOption {
          type = lib.types.ints.positive;
          default = 20;
          description = "Maximum PostgreSQL pool connections.";
        };

        minConnections = lib.mkOption {
          type = lib.types.ints.positive;
          default = 5;
          description = "Minimum PostgreSQL pool connections.";
        };

        maintenanceMaxConnections = lib.mkOption {
          type = lib.types.ints.positive;
          default = 5;
          description = ''
            Maximum connections for the maintenance pool (background/batch tasks).
            This pool is isolated from user requests, preventing background operations
            from starving interactive traffic.
          '';
        };

        maintenanceMinConnections = lib.mkOption {
          type = lib.types.ints.positive;
          default = 1;
          description = "Minimum connections for the maintenance pool.";
        };
      };

      auth = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable the authentication system.";
        };

        jwtSecret = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            JWT secret key for signing authentication tokens.
            If unset, a secure secret is auto-generated and persisted under storage.

            Warning: setting this option directly stores the secret in the Nix store.
            Prefer {option}`services.oxicloud.environmentFiles` for secrets.
          '';
        };

        accessTokenExpirySecs = lib.mkOption {
          type = lib.types.int;
          default = 3600;
          description = "Access token lifetime in seconds.";
        };

        refreshTokenExpirySecs = lib.mkOption {
          type = lib.types.int;
          default = 2592000;
          description = "Refresh token lifetime in seconds.";
        };
      };

      features = {
        userStorageQuotas = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable per-user storage quotas.";
        };

        fileSharing = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable file and folder sharing.";
        };

        trash = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable trash/recycle bin support.";
        };

        search = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable search support.";
        };
      };

      oidc = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable OIDC authentication.";
        };

        issuerUrl = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "OIDC provider issuer URL.";
        };

        clientId = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "OIDC client ID.";
        };

        clientSecret = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            OIDC client secret.

            Warning: setting this option directly stores the secret in the Nix store.
            Prefer {option}`services.oxicloud.environmentFiles` for secrets.
          '';
        };

        redirectUri = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "http://${cfg.settings.host}:${toString cfg.settings.port}/api/auth/oidc/callback";
          defaultText = lib.literalExpression ''
            "http://''${config.services.oxicloud.settings.host}:''${toString config.services.oxicloud.settings.port}/api/auth/oidc/callback"
          '';
          description = "OIDC callback URL.";
        };

        scopes = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "openid"
            "profile"
            "email"
          ];
          description = "OIDC scopes requested by OxiCloud.";
        };

        frontendUrl = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "http://${cfg.settings.host}:${toString cfg.settings.port}";
          defaultText = lib.literalExpression ''
            "http://''${config.services.oxicloud.settings.host}:''${toString config.services.oxicloud.settings.port}"
          '';
          description = "Frontend URL to redirect to after successful login.";
        };

        autoProvision = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Automatically create users on first OIDC login.";
        };

        adminGroups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "OIDC groups that grant admin role.";
        };

        disablePasswordLogin = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Disable password login when OIDC is enabled.";
        };

        providerName = lib.mkOption {
          type = lib.types.str;
          default = "SSO";
          description = "Display name for the OIDC provider.";
        };
      };

      wopi = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable WOPI integration for office document editing (Used with Collabora, OnlyOffice, or other WOPI-compatible editors).";
        };

        discoveryUrl = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "WOPI discovery URL.";
        };

        secret = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Secret key for signing WOPI access tokens.
            Falls back to {env}`OXICLOUD_JWT_SECRET` if unset.

            Warning: setting this option directly stores the secret in the Nix store.
            Prefer {option}`services.oxicloud.environmentFiles` for secrets.
          '';
        };

        tokenTtlSecs = lib.mkOption {
          type = lib.types.int;
          default = 86400;
          description = "WOPI access token lifetime in seconds.";
        };

        lockTtlSecs = lib.mkOption {
          type = lib.types.int;
          default = 1800;
          description = "WOPI lock expiration in seconds.";
        };
      };

      mimalloc = {
        purgeDelay = lib.mkOption {
          type = lib.types.int;
          default = 0;
          description = ''
            Delay in milliseconds before freed memory is returned to the OS.
            0 returns memory immediately.
          '';
        };

        allowLargeOsPages = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether mimalloc may use large OS pages.
          '';
        };
      };

      extraEnvironment = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.nullOr (
            lib.types.oneOf [
              lib.types.bool
              lib.types.int
              lib.types.str
            ]
          )
        );
        default = { };
        description = ''
          Additional environment variables for OxiCloud.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.settings.oidc.enable || cfg.settings.oidc.issuerUrl != null;
        message = "services.oxicloud.settings.oidc.issuerUrl must be set when oidc is enabled.";
      }
      {
        assertion = !cfg.settings.oidc.enable || cfg.settings.oidc.clientId != null;
        message = "services.oxicloud.settings.oidc.clientId must be set when oidc is enabled.";
      }
      {
        assertion = !cfg.settings.oidc.enable || cfg.settings.oidc.redirectUri != null;
        message = "services.oxicloud.settings.oidc.redirectUri must be set when oidc is enabled.";
      }
      {
        assertion = !cfg.settings.wopi.enable || cfg.settings.wopi.discoveryUrl != null;
        message = "services.oxicloud.settings.wopi.discoveryUrl must be set when WOPI is enabled.";
      }
      {
        assertion = cfg.settings.database.minConnections <= cfg.settings.database.maxConnections;
        message = "services.oxicloud.settings.database.minConnections must be <= maxConnections.";
      }
      {
        assertion =
          cfg.settings.database.maintenanceMinConnections <= cfg.settings.database.maintenanceMaxConnections;
        message = "services.oxicloud.settings.database.maintenanceMinConnections must be <= maintenanceMaxConnections.";
      }
    ];

    services.postgresql = lib.mkIf cfg.createLocalDatabase {
      enable = true;
      ensureDatabases = [ "oxicloud" ];
      ensureUsers = [
        {
          name = "oxicloud";
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.tmpfiles.rules = lib.optional cfg.createDataDir "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} -";

    users.users = lib.mkIf (cfg.user == defaultUser) {
      oxicloud = {
        isSystemUser = true;
        group = cfg.group;
        description = "OxiCloud service user";
      };
    };

    users.groups = lib.mkIf (cfg.group == defaultGroup) { oxicloud = { }; };

    systemd.services.oxicloud = {
      description = "OxiCloud server";
      wantedBy = [ "multi-user.target" ];

      after = [ "network.target" ] ++ lib.optional cfg.createLocalDatabase "postgresql.service";
      wants = [ "network.target" ] ++ lib.optional cfg.createLocalDatabase "postgresql.service";

      environment = env;

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        WorkingDirectory = cfg.dataDir;
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = "5s";

        ReadWritePaths = [
          cfg.dataDir
          cfg.settings.storagePath
        ];
        UMask = "0027";

        AmbientCapabilities = lib.optional (cfg.settings.port < 1024) "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = lib.optional (cfg.settings.port < 1024) "CAP_NET_BIND_SERVICE";

        DeviceAllow = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ flashonfire ];
}
