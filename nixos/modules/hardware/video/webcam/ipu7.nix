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
    mkIf
    mkOption
    optional
    types
    ;

  cfg = config.hardware.ipu7;

in
{

  options.hardware.ipu7 = {

    enable = mkEnableOption "support for Intel IPU7/MIPI cameras";

    platform = mkOption {
      type = types.enum [
        "ipu7x"
        "ipu75xa"
      ];
      description = ''
        Choose the version for your hardware platform. The IPU reports which one
        it is through its PCI ID, visible as the Multimedia controller in lspci.

        - ipu7x (Lunar Lake, PCI 8086:645d)
          Sensor list: https://github.com/intel/ipu7-camera-hal/tree/main/config/linux/ipu7x/sensors
        - ipu75xa (Panther Lake, PCI 8086:b05d)
          Sensor list: https://github.com/intel/ipu7-camera-hal/tree/main/config/linux/ipu75xa/sensors
      '';
    };

  };

  config = mkIf cfg.enable {

    # Kernels >= 6.17 ship an IPU7 core and ISys in drivers/staging/media/ipu7,
    # but no PSys, so they cannot drive the hardware ISP that the camera HAL
    # needs. ipu7-drivers supplies just the PSys module (intel-ipu7-psys), which
    # has no in-tree counterpart, and links it against the in-tree core and ISys
    # that already enumerate the sensor.
    boot.extraModulePackages = with config.boot.kernelPackages; [
      ipu7-drivers
    ];

    hardware.firmware = with pkgs; [
      ipu7-camera-bins
      ivsc-firmware
    ];

    services.udev.extraRules = ''
      SUBSYSTEM=="intel-ipu7-psys", MODE="0660", GROUP="video"
    '';

    services.v4l2-relayd.instances.ipu7 = {
      enable = mkDefault true;

      cardLabel = mkDefault "Intel MIPI Camera";

      extraPackages =
        with pkgs.gst_all_1;
        optional (cfg.platform == "ipu7x") icamerasrc-ipu7x
        ++ optional (cfg.platform == "ipu75xa") icamerasrc-ipu75xa;

      input = {
        pipeline = "icamerasrc";
        # REVIEW from https://edc.intel.com/content/www/us/en/secure/design/confidential/products/platforms/details/lunar-lake-mx/core-ultra-200v-series-processors-datasheet-volume-1-of-2/camera-integrated-isp/
        # Output Formats - NV12, NV16, I420, M420, YUY2, YUYV, P010, P016
        format = "NV12";
      };
    };
  };
}
