{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.photoview;

  dbUrl = {
    sqlite = "PHOTOVIEW_SQLITE_PATH=${cfg.dataDir}/photoview.db";
    mysql = "PHOTOVIEW_MYSQL_URL=${cfg.database.user}:$(cat $CREDENTIALS_DIRECTORY/db_password)@tcp(${cfg.database.host}:${toString cfg.database.port})/${cfg.database.name}";
    postgres = "PHOTOVIEW_POSTGRES_URL=postgres://${cfg.database.user}:$(cat $CREDENTIALS_DIRECTORY/db_password)@${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}";
  };
in

{
  options.services.photoview = {
    enable = lib.mkEnableOption "Photoview, a photo gallery for self-hosted personal servers";

    package = lib.mkPackageOption pkgs "photoview" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "photoview";
      description = "User account under which photoview runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "photoview";
      description = "Group under which photoview runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/photoview";
      description = "Directory for photoview state, cache, and database.";
    };

    mediaPath = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to the directory containing photos to be served.
        This directory must be readable by the photoview user.
      '';
      example = "/mnt/photos";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address to listen on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 4001;
      description = "Port to listen on.";
    };

    database = {
      type = lib.mkOption {
        type = lib.types.enum [
          "sqlite"
          "mysql"
          "postgres"
        ];
        default = "sqlite";
        description = "Database engine to use.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Database host address.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5432;
        description = "Database port.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "photoview";
        description = "Database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "photoview";
        description = "Database user.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to a file containing the database password.
          Required when using MySQL or PostgreSQL.
        '';
      };
    };

    settings = {
      disableFaceRecognition = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable face recognition feature.";
      };

      disableVideoEncoding = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable video encoding with FFmpeg.";
      };

      disableRawProcessing = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable RAW photo processing.";
      };

      mapboxToken = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Mapbox API token for map features.";
      };

      videoEncoder = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "h264_qsv"
            "h264_vaapi"
            "h264_nvenc"
          ]
        );
        default = null;
        description = "Hardware video encoder to use.";
      };
    };

    secretsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to an environment file containing secrets.
        Can be used for MAPBOX_TOKEN or other sensitive settings.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.type == "sqlite" || cfg.database.passwordFile != null;
        message = "services.photoview.database.passwordFile must be set when using MySQL or PostgreSQL.";
      }
    ];

    users.users = lib.mkIf (cfg.user == "photoview") {
      photoview = {
        group = cfg.group;
        home = cfg.dataDir;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "photoview") {
      photoview = { };
    };

    systemd.services.photoview = {
      description = "Photoview - Photo gallery for self-hosted personal servers";
      documentation = [ "https://photoview.github.io/docs/" ];
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ]
      ++ lib.optional (cfg.database.type == "postgres") "postgresql.service"
      ++ lib.optional (cfg.database.type == "mysql") "mysql.service";
      requires =
        lib.optional (cfg.database.type == "postgres") "postgresql.service"
        ++ lib.optional (cfg.database.type == "mysql") "mysql.service";

      environment = {
        PHOTOVIEW_DATABASE_DRIVER = cfg.database.type;
        PHOTOVIEW_LISTEN_IP = cfg.host;
        PHOTOVIEW_LISTEN_PORT = toString cfg.port;
        PHOTOVIEW_MEDIA_CACHE = "/var/cache/photoview";
        PHOTOVIEW_DISABLE_FACE_RECOGNITION = toString cfg.settings.disableFaceRecognition;
        PHOTOVIEW_DISABLE_VIDEO_ENCODING = toString cfg.settings.disableVideoEncoding;
        PHOTOVIEW_DISABLE_RAW_PROCESSING = toString cfg.settings.disableRawProcessing;
      }
      // lib.optionalAttrs (cfg.settings.mapboxToken != null) {
        MAPBOX_TOKEN = cfg.settings.mapboxToken;
      }
      // lib.optionalAttrs (cfg.settings.videoEncoder != null) {
        PHOTOVIEW_VIDEO_ENCODER = cfg.settings.videoEncoder;
      };

      script = ''
        export ${dbUrl.${cfg.database.type}}
        exec ${lib.getExe cfg.package}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "photoview";
        StateDirectoryMode = "0750";
        CacheDirectory = "photoview";
        CacheDirectoryMode = "0750";
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
        RestartSec = 5;

        # Read access to media directory
        ReadOnlyPaths = [ cfg.mediaPath ];

        # Secrets
        LoadCredential = lib.optional (
          cfg.database.passwordFile != null
        ) "db_password:${cfg.database.passwordFile}";
        EnvironmentFile = lib.optional (cfg.secretsFile != null) cfg.secretsFile;

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
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
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ nettika ];
}
