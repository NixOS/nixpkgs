{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.juicefs;

  volumeOptions = lib.types.submodule {
    options = {
      # Basic options
      name = lib.mkOption {
        type = lib.types.str;
        description = "Name of the JuiceFS volume";
      };

      mountPoint = lib.mkOption {
        type = lib.types.str;
        description = "Mount point for the volume";
      };

      metaUrl = lib.mkOption {
        type = lib.types.str;
        description = "Redis URL for metadata (e.g., redis://localhost:6379/1)";
      };

      # Storage options
      storage = lib.mkOption {
        type = lib.types.str;
        default = "file";
        description = "Storage type (e.g., s3, gs, oss, cos)";
      };

      bucket = lib.mkOption {
        type = lib.types.str;
        default = "/var/jfs";
        description = "Bucket URL for object storage";
      };

      accessKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Access key for object storage";
      };

      secretKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Secret key for object storage";
      };

      storageOptions = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          endpoint = "minio.example.com:9000";
        };
        description = "Additional storage options (like endpoint for S3)";
      };

      # Cache options
      cacheDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/cache/juicefs";
        description = "Directory for local cache";
      };

      cacheSize = lib.mkOption {
        type = lib.types.str;
        default = "100G";
        description = "Size of local cache";
      };

      compress = lib.mkOption {
        type = lib.types.enum [
          "none"
          "lz4"
          "zstd"
        ];
        default = "none";
        description = "Compression algorithm";
      };

      writeback = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable write back cache for better performance";
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Additional arguments for mount command";
        example = [
          "--no-verify-ssl"
          "--cache-partial-only"
        ];
      };
    };
  };

in
{
  options.services.juicefs = {
    enable = lib.mkEnableOption "JuiceFS Service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.juicefs;
      description = "JuiceFS package to use";
    };

    volumes = lib.mkOption {
      type = lib.types.attrsOf volumeOptions;
      default = { };
      description = "Set of JuiceFS volumes to mount";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Create cache directories
    systemd.tmpfiles.rules = lib.concatLists (
      lib.mapAttrsToList (name: volume: [
        "d ${volume.cacheDir} 0755 root root -"
      ]) cfg.volumes
    );

    systemd.services = lib.mapAttrs' (
      name: volume:
      lib.nameValuePair "juicefs-${name}" {
        description = "JuiceFS volume ${name}";

        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        requires = [ "network-online.target" ];
        after = [ "network-online.target" ];

        serviceConfig = {
          Type = "forking";

          # Environment variables for credentials and settings
          Environment =
            [
              "JFS_NO_UPDATE_FSTAB=1"
              "AWS_ENDPOINT=${volume.storageOptions.endpoint or ""}"
            ]
            ++ lib.optional (volume.accessKey != "") "ACCESS_KEY=${volume.accessKey}"
            ++ lib.optional (volume.secretKey != "") "SECRET_KEY=${volume.secretKey}";

          # Initialize the volume if needed
          ExecStartPre = pkgs.writeShellScript "juicefs-init-${name}" ''
            set -e
            export PATH="${pkgs.coreutils}/bin:$PATH"

            # Check if volume needs formatting
            if ! ${cfg.package}/bin/juicefs status ${volume.metaUrl} >/dev/null 2>&1; then
              echo "Formatting JuiceFS volume ${volume.name}..."
              ${cfg.package}/bin/juicefs format \
                ${volume.metaUrl} \
                ${volume.name} \
                --storage ${volume.storage} \
                --bucket ${volume.bucket} \
                --compress ${volume.compress}
            else
              echo "JuiceFS volume ${volume.name} already formatted."
            fi

            # Create required directories
            mkdir -p ${volume.mountPoint}
            mkdir -p ${volume.cacheDir}
          '';

          # Mount the volume
          ExecStart = pkgs.writeShellScript "juicefs-mount-${name}" ''
            set -e
            ${cfg.package}/bin/juicefs mount \
              ${volume.metaUrl} \
              ${volume.mountPoint} \
              --background \
              ${lib.optionalString volume.writeback "--writeback"} \
              --cache-dir ${volume.cacheDir} \
              --cache-size ${volume.cacheSize} \
              ${lib.concatStringsSep " " volume.extraArgs}
          '';

          # Unmount command
          ExecStop = "${cfg.package}/bin/juicefs umount ${volume.mountPoint}";

          # Restart settings
          Restart = "on-failure";
          RestartSec = "5s";
        };
      }
    ) cfg.volumes;
  };
}
