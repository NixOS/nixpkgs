{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.hotResize;
  devicesJson = builtins.toJSON (
    map (dev: {
      device = dev.device;
      fs_type = dev.fsType;
      mount_point = dev.mountPoint;
    }) cfg.devices
  );

in

{
  options.services.hotResize = {
    enable = lib.mkEnableOption "the hot resize service for filesystems";

    package = lib.mkPackageOption pkgs "hot-resize" { };

    devices = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            device = lib.mkOption {
              type = lib.types.str;
              example = "/dev/sda1";
              description = "Block device path to resize";
            };
            fsType = lib.mkOption {
              type = lib.types.enum [
                "ext4"
                "xfs"
                "btrfs"
              ];
              default = "ext4";
              description = "Filesystem type (supported: ext4, xfs, btrfs)";
            };
            mountPoint = lib.mkOption {
              type = lib.types.str;
              example = "/";
              description = "Mount point of the filesystem to resize";
            };
          };
        }
      );
      default = [ ];
      example = lib.literalExpression ''
        [
          {
            device = "/dev/sda1";
            fsType = "ext4";
            mountPoint = "/";
          }
        ]
      '';
      description = "List of devices to monitor for resizing";
    };

    skipVerify = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Skip filesystem verification after resize";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.hotResize = {
      description = "Hot resize service for filesystems";
      wantedBy = [ "multi-user.target" ];
      requires = [ "local-fs-pre.target" ];
      after = [ "local-fs-pre.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = false;
        ExecStart =
          "${lib.getExe cfg.package}"
          + " --devices '${devicesJson}'"
          + lib.optionalString cfg.skipVerify " --skip-verify";
      };
    };
  };
}
