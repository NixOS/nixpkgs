{
  config,
  lib,
  pkgs,
  ...
}:
let

  inherit (lib)
    mkDefault
    mkEnableOption
    mkForce
    mkIf
    mkOption
    optional
    types
    ;

  cfg = config.hardware.ipu6;

in
{

  options.hardware.ipu6 = {

    enable = mkEnableOption "support for Intel IPU6/MIPI cameras";

    platform = mkOption {
      type = types.enum [
        "ipu6"
        "ipu6ep"
        "ipu6epmtl"
      ];
      description = ''
        Choose the version for your hardware platform.

        Use `ipu6` for Tiger Lake, `ipu6ep` for Alder Lake or Raptor Lake,
        and `ipu6epmtl` for Meteor Lake.
      '';
    };

    videoDeviceNumber = mkOption {
      type = types.int;
      default = 50;
      description = ''
        v4l2loopback device number for the relay output (`/dev/videoN`).

        Must be fixed so application camera permission grants, which are keyed to
        the PipeWire node name (derived from the sysfs device path), survive
        reboots. Choose a number above the IPU6 raw node range (typically 3-34)
        and any other v4l2loopback devices on the system.
      '';
    };

  };

  config = mkIf cfg.enable {

    # Module is upstream as of 6.10,
    # but still needs various out-of-tree i2c and the `intel-ipu6-psys` kernel driver
    boot.extraModulePackages = with config.boot.kernelPackages; [ ipu6-drivers ];

    hardware.firmware = with pkgs; [
      ipu6-camera-bins
      ivsc-firmware
    ];

    # Restrict IPU6 raw nodes and media controller to root. DRIVERS== matches the
    # parent PCI device. TAG-="uaccess" blocks logind ACL grants at login.
    services.udev.extraRules = ''
      SUBSYSTEM=="intel-ipu6-psys", MODE="0660", GROUP="video"
      SUBSYSTEM=="media", DRIVERS=="intel-ipu6", MODE="0600", GROUP="root", TAG-="uaccess"
      SUBSYSTEM=="video4linux", DRIVERS=="intel-ipu6", MODE="0600", GROUP="root", TAG-="uaccess"
    '';

    # ipu6-camera-hal writes AIQ tuning data and debug logs here.
    systemd.tmpfiles.rules = [ "d /run/camera 0755 root video -" ];

    # Disable raw IPU6 nodes in WirePlumber. Matched via udev ID_V4L_PRODUCT=ipu6,
    # set by the kernel at device registration without requiring a device open.
    services.pipewire.wireplumber.extraConfig."ipu6-v4l2-rules" = {
      "monitor.v4l2.rules" = [
        {
          matches = [ { "device.product.name" = "ipu6"; } ];
          actions = {
            "update-props" = {
              "device.disabled" = true;
            };
          };
        }
      ];
    };

    services.v4l2-relayd.instances.ipu6 = {
      enable = mkDefault true;

      cardLabel = mkDefault "Intel MIPI Camera";

      extraPackages =
        with pkgs.gst_all_1;
        [ ]
        ++ optional (cfg.platform == "ipu6") icamerasrc-ipu6
        ++ optional (cfg.platform == "ipu6ep") icamerasrc-ipu6ep
        ++ optional (cfg.platform == "ipu6epmtl") icamerasrc-ipu6epmtl;

      input = {
        pipeline = "icamerasrc";
        format = mkIf (cfg.platform != "ipu6") (mkDefault "NV12");
      };
    };

    # Override preStart/postStop from the v4l2-relayd module:
    # - Use a fixed device number so PipeWire node names (and application permission
    #   grants) are stable across reboots. Exit 17 (EEXIST) is success.
    # - Keep the device alive on stop so apps survive relay restarts via
    #   VIDIOC_DQBUF blocking rather than receiving errors.
    systemd.services.v4l2-relayd-ipu6 = {
      preStart = mkForce ''
        mkdir -p "$(dirname "$V4L2_DEVICE_FILE")"
        ${config.boot.kernelPackages.v4l2loopback.bin}/bin/v4l2loopback-ctl \
          add --name "Intel MIPI Camera" --exclusive-caps=1 ${toString cfg.videoDeviceNumber} || [ $? -eq 17 ]
        echo /dev/video${toString cfg.videoDeviceNumber} > "$V4L2_DEVICE_FILE"
      '';
      postStop = mkForce ''
        rm -rf "$(dirname "$V4L2_DEVICE_FILE")"
      '';
    };

  };
}
