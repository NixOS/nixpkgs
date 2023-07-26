{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.rustus;
in
{
  meta.maintainers = with maintainers; [ happysalada ];

  options.services.rustus = {

    enable = mkEnableOption (lib.mdDoc "TUS protocol implementation in Rust.");

    host = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        The host that rustus will connect to.
      '';
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    port = mkOption {
      type = types.port;
      description = lib.mdDoc ''
        The port that rustus will connect to.
      '';
      default = 1081;
      example = 1081;
    };

    log_level = mkOption {
      type = types.enum [ "DEBUG" "INFO" "ERROR" ];
      description = lib.mdDoc ''
        Desired log level
      '';
      default = "INFO";
      example = "ERROR";
    };

    max_body_size = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        Maximum body size in bytes
      '';
      default = "10000000"; # 10 mb
      example = "100000000";
    };

    url = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        url path for uploads
      '';
      default = "/files";
    };

    disable_health_access_logs = mkOption {
      type = types.bool;
      description = lib.mdDoc ''
        disable access log for /health endpoint
      '';
      default = false;
    };

    cors = mkOption {
      type = types.listOf types.str;
      description = lib.mdDoc ''
        list of origins allowed to upload
      '';
      default = ["*"];
      example = ["*.staging.domain" "*.prod.domain"];
    };

    tus_extensions = mkOption {
      type = types.listOf (types.enum [
        "getting"
        "creation"
        "termination"
        "creation-with-upload"
        "creation-defer-length"
        "concatenation"
        "checksum"
      ]);
      description = lib.mdDoc ''
        Since TUS protocol offers extensibility you can turn off some protocol extensions.
      '';
      default = [
        "getting"
        "creation"
        "termination"
        "creation-with-upload"
        "creation-defer-length"
        "concatenation"
        "checksum"
      ];
    };

    remove_parts = mkOption {
      type = types.bool;
      description = lib.mdDoc ''
        remove parts files after successful concatenation
      '';
      default = true;
      example = false;
    };

    storage = lib.mkOption {
      description = lib.mdDoc ''
        Storages are used to actually store your files. You can configure where you want to store files.
      '';
      default = {};
      example = lib.literalExpression ''
        {
          type = "hybrid-s3"
          s3_access_key_file = konfig.age.secrets.R2_ACCESS_KEY.path;
          s3_secret_key_file = konfig.age.secrets.R2_SECRET_KEY.path;
          s3_bucket = "my_bucket";
          s3_url = "https://s3.example.com";
        }
      '';
      type = lib.types.submodule {
        options = {
          type = lib.mkOption {
            type = lib.types.enum ["file-storage" "hybrid-s3"];
            description = lib.mdDoc "Type of storage to use";
          };
          s3_access_key_file = lib.mkOption {
            type = lib.types.str;
            description = lib.mdDoc "File path that contains the S3 access key.";
          };
          s3_secret_key_file = lib.mkOption {
            type = lib.types.path;
            description = lib.mdDoc "File path that contains the S3 secret key.";
          };
          s3_region = lib.mkOption {
            type = lib.types.str;
            default = "us-east-1";
            description = lib.mdDoc "S3 region name.";
          };
          s3_bucket = lib.mkOption {
            type = lib.types.str;
            description = lib.mdDoc "S3 bucket.";
          };
          s3_url = lib.mkOption {
            type = lib.types.str;
            description = lib.mdDoc "S3 url.";
          };

          force_sync = lib.mkOption {
            type = lib.types.bool;
            description = lib.mdDoc "calls fsync system call after every write to disk in local storage";
            default = true;
          };
          data_dir = lib.mkOption {
            type = lib.types.str;
            description = lib.mdDoc "path to the local directory where all files are stored";
            default = "/var/lib/rustus";
          };
          dir_structure = lib.mkOption {
            type = lib.types.str;
            description = lib.mdDoc "pattern of a directory structure locally and on s3";
            default = "{year}/{month}/{day}";
          };
        };
      };
    };

    info_storage = lib.mkOption {
      description = lib.mdDoc ''
        Info storages are used to store information about file uploads. These storages must be persistent, because every time chunk is uploaded rustus updates information about upload. And when someone wants to download file, information about it requested from storage to get actual path of an upload.
      '';
      default = {};
      type = lib.types.submodule {
        options = {
          type = lib.mkOption {
            type = lib.types.enum ["file-info-storage"];
            description = lib.mdDoc "Type of info storage to use";
            default = "file-info-storage";
          };
          dir = lib.mkOption {
            type = lib.types.str;
            description = lib.mdDoc "directory to store info about uploads";
            default = "/var/lib/rustus";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.rustus =
      let
        isHybridS3 = cfg.storage.type == "hybrid-s3";
      in
    {
      description = "Rustus server";
      documentation = [ "https://s3rius.github.io/rustus/" ];

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        RUSTUS_SERVER_HOST = cfg.host;
        RUSTUS_SERVER_PORT = toString cfg.port;
        RUSTUS_LOG_LEVEL = cfg.log_level;
        RUSTUS_MAX_BODY_SIZE = cfg.max_body_size;
        RUSTUS_URL = cfg.url;
        RUSTUS_DISABLE_HEALTH_ACCESS_LOG = lib.mkIf cfg.disable_health_access_logs "true";
        RUSTUS_CORS = lib.concatStringsSep "," cfg.cors;
        RUSTUS_TUS_EXTENSIONS = lib.concatStringsSep "," cfg.tus_extensions;
        RUSTUS_REMOVE_PARTS= if cfg.remove_parts then "true" else "false";
        RUSTUS_STORAGE = cfg.storage.type;
        RUSTUS_DATA_DIR = cfg.storage.data_dir;
        RUSTUS_DIR_STRUCTURE = cfg.storage.dir_structure;
        RUSTUS_FORCE_FSYNC = if cfg.storage.force_sync then "true" else "false";
        RUSTUS_S3_URL = mkIf isHybridS3 cfg.storage.s3_url;
        RUSTUS_S3_BUCKET = mkIf isHybridS3 cfg.storage.s3_bucket;
        RUSTUS_S3_REGION = mkIf isHybridS3 cfg.storage.s3_region;
        RUSTUS_S3_ACCESS_KEY_PATH = mkIf isHybridS3 "%d/S3_ACCESS_KEY_PATH";
        RUSTUS_S3_SECRET_KEY_PATH = mkIf isHybridS3 "%d/S3_SECRET_KEY_PATH";
        RUSTUS_INFO_STORAGE = cfg.info_storage.type;
        RUSTUS_INFO_DIR = cfg.info_storage.dir;
      };

      serviceConfig = {
        ExecStart = "${pkgs.rustus}/bin/rustus";
        StateDirectory = "rustus";
        # User name is defined here to enable restoring a backup for example
        # You will run the backup restore command as sudo -u rustus in order
        # to have write permissions to /var/lib
        User = "rustus";
        DynamicUser = true;
        LoadCredential = lib.optionals isHybridS3 [
          "S3_ACCESS_KEY_PATH:${cfg.storage.s3_access_key_file}"
          "S3_SECRET_KEY_PATH:${cfg.storage.s3_secret_key_file}"
        ];
        # hardening
        RestrictRealtime=true;
        RestrictNamespaces=true;
        LockPersonality=true;
        ProtectKernelModules=true;
        ProtectKernelTunables=true;
        ProtectKernelLogs=true;
        ProtectControlGroups=true;
        ProtectHostUserNamespaces=true;
        ProtectClock=true;
        RestrictSUIDSGID=true;
        SystemCallArchitectures="native";
        CapabilityBoundingSet="";
        ProtectProc = "invisible";
        # TODO consider SystemCallFilter LimitAS ProcSubset
      };
    };
  };
}
