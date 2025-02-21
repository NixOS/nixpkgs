{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.hotResize;

  resize-script = pkgs.writeShellApplication {
    name = "hot-resize";
    runtimeInputs = with pkgs; [
      cloud-utils
      e2fsprogs
      parted
      util-linux
      btrfs-progs
      xfsprogs
      coreutils
    ];

    text = ''
      process_device() {
        local device="$1"
        local fstype="$2"
        local mountpoint="$3"

        echo "Processing $device ($fstype) mounted at $mountpoint..."

        REAL_DEVICE=$(readlink -f "$device")
        DISK=$(lsblk -Pno pkname "$REAL_DEVICE" | sed 's/PKNAME="\(.*\)"/\1/')
        PART_NUM=$(echo "$device" | grep -o '[0-9]*$')

        if [ -z "$DISK" ] || [ -z "$PART_NUM" ]; then
          echo "Failed to determine disk and partition number for $device"
          return 1
        fi

        echo "Growing partition /dev/$DISK partition $PART_NUM..."
        GROWPART_OUTPUT=$(growpart "/dev/$DISK" "$PART_NUM" 2>&1) || {
        EXIT_CODE=$?
        if [ $EXIT_CODE -eq 2 ] || ([ $EXIT_CODE -eq 1 ] && echo "$GROWPART_OUTPUT" | grep -q "NOCHANGE"); then
           echo "Partition is already at maximum size, continuing with filesystem resize..."
        else
           echo "Failed to grow partition: $GROWPART_OUTPUT"
          return $EXIT_CODE
        fi
        }

        echo "Resizing filesystem..."
        case "$fstype" in
          ext4)
            resize2fs "$device"
            ;;
          xfs)
            xfs_growfs "$mountpoint"
            ;;
          btrfs)
            btrfs filesystem resize max "$mountpoint"
            ;;
          *)
            echo "Unsupported filesystem type: $fstype"
            return 1
            ;;
        esac

        echo "Current size:"
        df -h "$mountpoint"
        echo "---"
      }

      # Process all devices passed as arguments
      while [ $# -ge 3 ]; do
        process_device "$1" "$2" "$3"
        shift 3
      done
    '';
  };

in
{
  options.services.hotResize = {
    enable = lib.mkEnableOption "the hot resize service for filesystems";

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
          {
            device = "/dev/sdb1";
            fsType = "xfs";
            mountPoint = "/data";
          }
        ]
      '';
      description = "List of devices to monitor for resizing";
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
          let
            deviceArgs = lib.concatMapStrings (
              dev: ''"${dev.device}" "${dev.fsType}" "${dev.mountPoint}" ''
            ) cfg.devices;
          in
          "${lib.getExe resize-script} ${deviceArgs}";
      };
    };
  };
}
