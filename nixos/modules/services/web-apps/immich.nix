{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    hasAttr
    hasPrefix
    maintainers
    mapAttrs
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    optional
    optionalAttrs
    optionalString
    types
    ;

  cfg = config.services.immich;
  serverCfg = config.services.immich.server;
  backendCfg = serverCfg.backend;
  microservicesCfg = serverCfg.microservices;
  webCfg = cfg.web;
  mlCfg = cfg.machineLearning;

  isServerPostgresUnix = hasPrefix "/" serverCfg.postgres.host;
  postgresEnv =
    if isServerPostgresUnix
    then {
      # If passwordFile is given, this will be overwritten in ExecStart
      DB_URL = "socket://${serverCfg.postgres.host}?dbname=${serverCfg.postgres.database}";
    }
    else {
      DB_HOSTNAME = serverCfg.postgres.host;
      DB_PORT = toString serverCfg.postgres.port;
      DB_DATABASE_NAME = serverCfg.postgres.database;
      DB_USERNAME = serverCfg.postgres.username;
    };

  typesenseEnv = {
    TYPESENSE_ENABLED = toString serverCfg.typesense.enable;
  } // optionalAttrs serverCfg.typesense.enable {
    TYPESENSE_HOST = serverCfg.typesense.host;
    TYPESENSE_PORT = toString serverCfg.typesense.port;
    TYPESENSE_PROTOCOL = serverCfg.typesense.protocol;
  };

  serverMachineLearningEnv = {
    IMMICH_MACHINE_LEARNING_ENABLED = toString serverCfg.machineLearning.enable;
  } // optionalAttrs serverCfg.machineLearning.enable {
    IMMICH_MACHINE_LEARNING_URL = serverCfg.machineLearning.url;
  };

  # Don't start a redis instance if the user sets a custom redis connection
  enableRedis = !hasAttr "REDIS_URL" serverCfg.extraConfig && !hasAttr "REDIS_SOCKET" serverCfg.extraConfig;
  redisServerCfg = config.services.redis.servers.immich;
  redisEnv = optionalAttrs enableRedis {
    REDIS_SOCKET = redisServerCfg.unixSocket;
  };

  serverEnv = postgresEnv // typesenseEnv // serverMachineLearningEnv // redisEnv // {
    NODE_ENV = "production";
    IMMICH_MEDIA_LOCATION = serverCfg.mediaDir;
  };

  serverStartWrapper = program: ''
    set -euo pipefail
    mkdir -p ${serverCfg.mediaDir}

    ${optionalString (serverCfg.postgres.passwordFile != null) (
      if isServerPostgresUnix
      then ''export DB_URL="socket://${serverCfg.postgres.username}:$(cat ${serverCfg.postgres.passwordFile})@${serverCfg.postgres.host}?dbname=${serverCfg.postgres.database}"''
      else "export DB_PASSWORD=$(cat ${serverCfg.postgres.passwordFile})"
    )}

    ${optionalString serverCfg.typesense.enable ''
      export TYPESENSE_API_KEY=$(cat ${serverCfg.typesense.apiKeyFile})
    ''}

    exec ${program}
  '';

  commonServiceConfig = {
    Restart = "on-failure";

    # Hardening
    CapabilityBoundingSet = "";
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    PrivateUsers = true;
    PrivateTmp = true;
    PrivateDevices = true;
    PrivateMounts = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    # Would re-mount paths ignored by temporary root
    # TODO ProtectSystem = "strict";
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
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
      "@pkey"
    ];
    UMask = "0077";
  };

  serverServiceConfig = {
    DynamicUser = true;
    User = "immich";
    Group = "immich";
    SupplementaryGroups = optional enableRedis redisServerCfg.user;

    StateDirectory = "immich";
    StateDirectoryMode = "0750";
    WorkingDirectory = "/var/lib/immich";

    MemoryDenyWriteExecute = false; # nodejs requires this.
    EnvironmentFile = mkIf (serverCfg.environmentFile != null) serverCfg.environmentFile;

    TemporaryFileSystem = "/:ro";
    BindReadOnlyPaths = [
      "/nix/store"
      "-/etc/resolv.conf"
      "-/etc/nsswitch.conf"
      "-/etc/hosts"
      "-/etc/localtime"
      "-/run/postgresql"
    ] ++ optional enableRedis redisServerCfg.unixSocket;
  };
in {
  options.services.immich = {
    enable = mkEnableOption "immich" // {
      description = ''
        Enables immich which consists of a backend server, microservices,
        machine-learning and web ui. You can disable or reconfigure components
        individually using the subsections.
      '';
    };

    package = mkPackageOption pkgs "immich" {};

    server = {
      mediaDir = mkOption {
        type = types.str;
        default = "/var/lib/immich/media";
        description = "Directory used to store media files.";
      };

      backend = {
        enable = mkEnableOption "immich backend server" // {
          default = true;
        };
        port = mkOption {
          type = types.port;
          default = 3001;
          description = "Port to bind to.";
        };

        openFirewall = mkOption {
          default = false;
          type = types.bool;
          description = "Whether to open the firewall for the specified port.";
        };

        extraConfig = mkOption {
          type = types.attrs;
          default = {};
          example = {
            LOG_LEVEL = "debug";
          };
          description = ''
            Extra configuration options (environment variables).
            Refer to [the documented variables](https://documentation.immich.app/docs/install/environment-variables) tagged with 'server' for available options.
          '';
        };

        environmentFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Environment file as defined in systemd.exec(5). May be used to provide
            additional secret variables to the service without adding them to the
            world-readable Nix store.
          '';
        };
      };

      microservices = {
        enable = mkEnableOption "immich microservices" // {
          default = true;
        };

        port = mkOption {
          type = types.port;
          default = 3002;
          description = "Port to bind to.";
        };

        openFirewall = mkOption {
          default = false;
          type = types.bool;
          description = "Whether to open the firewall for the specified port.";
        };

        extraConfig = mkOption {
          type = types.attrs;
          default = {};
          example = {
            REVERSE_GEOCODING_PRECISION = 1;
          };
          description = ''
            Extra configuration options (environment variables).
            Refer to [the documented variables](https://documentation.immich.app/docs/install/environment-variables) tagged with 'microservices' for available options.
          '';
        };

        environmentFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Environment file as defined in systemd.exec(5). May be used to provide
            additional secret variables to the service without adding them to the
            world-readable Nix store.
          '';
        };
      };

      typesense = {
        enable = mkEnableOption "typesense" // {
          default = true;
        };

        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          example = "typesense.example.com";
          description = "Hostname/address of the typesense server to use.";
        };

        port = mkOption {
          type = types.port;
          default = 8108;
          description = "The port of the typesense server to use.";
        };

        protocol = mkOption {
          type = types.str;
          default = "http";
          description = "The protocol to use when connecting to the typesense server.";
        };

        apiKeyFile = mkOption {
          type = types.path;
          description = "Sets the api key for authentication with typesense.";
        };
      };

      postgres = {
        host = mkOption {
          type = types.str;
          default = "/run/postgresql";
          description = "Hostname/address of the postgres server to use. If an absolute path is given here, it will be interpreted as a unix socket path.";
        };

        port = mkOption {
          type = types.port;
          default = 5432;
          description = "The port of the postgres server to use.";
        };

        username = mkOption {
          type = types.str;
          default = "immich";
          description = "The postgres username to use.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Sets the password for authentication with postgres.
            May be unset when using socket authentication.
          '';
        };

        database = mkOption {
          type = types.str;
          default = "immich";
          description = "The postgres database to use.";
        };
      };

      machineLearning = {
        enable = mkEnableOption "machine learning by utilizing the specified ML endpoint" // {
          default = true;
        };

        url = mkOption {
          type = types.str;
          default = "http://127.0.0.1:3003";
          example = "https://immich-ml.internal.example.com";
          description = "The machine learning server endpoint to use.";
        };
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        example = {
          REDIS_SOCKET = "/run/custom-redis";
        };
        description = ''
          Extra configuration options (environment variables) for both backend and microservices.
          Refer to [the documented variables](https://documentation.immich.app/docs/install/environment-variables) tagged with both 'server' and 'microservices' for available options.
        '';
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Environment file as defined in systemd.exec(5). May be used to provide
          additional secret variables to the backend and microservices servers without
          adding them to the world-readable Nix store.
        '';
      };
    };

    web = {
      enable = mkEnableOption "immich web frontend" // {
        default = true;
      };

      port = mkOption {
        type = types.port;
        default = 3000;
        description = "Port to bind to.";
      };

      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to open the firewall for the specified port.";
      };

      serverUrl = mkOption {
        type = types.str;
        default = "http://127.0.0.1:3001";
        example = "https://immich-backend.internal.example.com";
        description = "The backend server url to use.";
      };

      apiUrlExternal = mkOption {
        type = types.str;
        default = "/web";
        description = "The api url to use for external requests.";
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        example = {
          PUBLIC_LOGIN_PAGE_MESSAGE = "My awesome Immich instance!";
        };
        description = ''
          Extra configuration options (environment variables).
          Refer to [the documented variables](https://documentation.immich.app/docs/install/environment-variables) tagged with 'web' for available options.
        '';
      };
    };

    machineLearning = {
      enable = mkEnableOption "immich machine-learning server" // {
        default = true;
      };

      port = mkOption {
        type = types.port;
        default = 3003;
        description = "Port to bind to.";
      };

      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to open the firewall for the specified port.";
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        example = {
          MACHINE_LEARNING_MODEL_TTL = 600;
        };
        description = ''
          Extra configuration options (environment variables).
          Refer to [the documented variables](https://documentation.immich.app/docs/install/environment-variables) tagged with 'machine learning' for available options.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !isServerPostgresUnix -> serverCfg.postgres.passwordFile != null;
        message = "A database password must be provided when unix sockets are not used.";
      }
    ];

    networking.firewall.allowedTCPPorts = mkMerge [
      (mkIf (backendCfg.enable && backendCfg.openFirewall) [backendCfg.port])
      (mkIf (microservicesCfg.enable && microservicesCfg.openFirewall) [microservicesCfg.port])
      (mkIf (webCfg.enable && webCfg.openFirewall) [webCfg.port])
      (mkIf (mlCfg.enable && mlCfg.openFirewall) [mlCfg.port])
    ];

    services.redis.servers.immich.enable = mkIf enableRedis true;
    services.redis.vmOverCommit = mkIf enableRedis (mkDefault true);

    systemd.services.immich-server = mkIf backendCfg.enable {
      description = "Immich backend server (Self-hosted photo and video backup solution)";
      after = [
        "network.target"
        "typesense.service"
        "postgresql.service"
        "immich-machine-learning.service"
      ] ++ optional enableRedis "redis-immich.service";
      wantedBy = ["multi-user.target"];

      environment = serverEnv // {
        SERVER_PORT = toString backendCfg.port;
      }
      // mapAttrs (_: toString) serverCfg.extraConfig
      // mapAttrs (_: toString) backendCfg.extraConfig;

      script = serverStartWrapper "${cfg.package}/bin/server";
      serviceConfig = mkMerge [
        (commonServiceConfig // serverServiceConfig)
        {
          EnvironmentFile = mkIf (backendCfg.environmentFile != null) backendCfg.environmentFile;
        }
      ];
    };

    systemd.services.immich-microservices = mkIf microservicesCfg.enable {
      description = "Immich microservices (Self-hosted photo and video backup solution)";
      after = [
        "network.target"
        "typesense.service"
        "postgresql.service"
        "immich-machine-learning.service"
      ] ++ optional enableRedis "redis-immich.service";
      wantedBy = ["multi-user.target"];

      environment = serverEnv // {
        MICROSERVICES_PORT = toString microservicesCfg.port;
      }
      // mapAttrs (_: toString) serverCfg.extraConfig
      // mapAttrs (_: toString) microservicesCfg.extraConfig;

      script = serverStartWrapper "${cfg.package}/bin/microservices";
      serviceConfig = mkMerge [
        (commonServiceConfig // serverServiceConfig)
        {
          EnvironmentFile = mkIf (microservicesCfg.environmentFile != null) microservicesCfg.environmentFile;
        }
      ];
    };

    systemd.services.immich-web = mkIf webCfg.enable {
      description = "Immich web (Self-hosted photo and video backup solution)";
      after = [
        "network.target"
        "immich-server.service"
      ];
      wantedBy = ["multi-user.target"];

      environment = {
        NODE_ENV = "production";
        PORT = toString webCfg.port;
        IMMICH_SERVER_URL = webCfg.serverUrl;
        IMMICH_API_URL_EXTERNAL = webCfg.apiUrlExternal;
      }
      // mapAttrs (_: toString) webCfg.extraConfig;

      script = ''
        set -euo pipefail
        export PUBLIC_IMMICH_SERVER_URL=$IMMICH_SERVER_URL
        export PUBLIC_IMMICH_API_URL_EXTERNAL=$IMMICH_API_URL_EXTERNAL
        exec ${cfg.package.web}/bin/web
      '';
      serviceConfig = commonServiceConfig // {
        DynamicUser = true;
        User = "immich-web";
        Group = "immich-web";

        MemoryDenyWriteExecute = false; # nodejs requires this.

        TemporaryFileSystem = "/:ro";
        BindReadOnlyPaths = [
          "/nix/store"
          "-/etc/resolv.conf"
          "-/etc/nsswitch.conf"
          "-/etc/hosts"
          "-/etc/localtime"
        ];
      };
    };

    systemd.services.immich-machine-learning = mkIf mlCfg.enable {
      description = "Immich machine learning (Self-hosted photo and video backup solution)";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      environment = {
        NODE_ENV = "production";
        MACHINE_LEARNING_PORT = toString mlCfg.port;

        MACHINE_LEARNING_CACHE_FOLDER = "/var/cache/immich-ml";
        TRANSFORMERS_CACHE = "/var/cache/immich-ml";
      }
      // mapAttrs (_: toString) mlCfg.extraConfig;

      serviceConfig = commonServiceConfig // {
        ExecStart = "${cfg.package.machine-learning}/bin/machine-learning";
        DynamicUser = true;
        User = "immich-ml";
        Group = "immich-ml";

        MemoryDenyWriteExecute = false; # onnxruntime_pybind11 requires this.
        ProcSubset = "all"; # Needs /proc/cpuinfo

        CacheDirectory = "immich-ml";
        CacheDirectoryMode = "0700";

        # TODO gpu access

        TemporaryFileSystem = "/:ro";
        BindReadOnlyPaths = [
          "/nix/store"
          "-/etc/resolv.conf"
          "-/etc/nsswitch.conf"
          "-/etc/hosts"
          "-/etc/localtime"
        ];
      };
    };

    meta.maintainers = with maintainers; [ oddlama ];
  };
}
