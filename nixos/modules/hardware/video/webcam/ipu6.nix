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
    lib.mkOption
    lib.optional
    types
    ;

  cfg = config.hardware.ipu6;

in
{

  options.hardware.ipu6 = {

    enable = lib.mkEnableOption "support for Intel IPU6/MIPI cameras";

    platform = lib.mkOption {
      type = lib.types.enum [
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

  };

  config = lib.mkIf cfg.enable {

    # Module is upstream as of 6.10,
    # but still needs various out-of-tree i2c and the `intel-ipu6-psys` kernel driver
    boot.extraModulePackages = with config.boot.kernelPackages; [ ipu6-drivers ];

    hardware.firmware = with pkgs; [
      ipu6-camera-bins
      ivsc-firmware
    ];

    services.udev.extraRules = ''
      SUBSYSTEM=="intel-ipu6-psys", MODE="0660", GROUP="video"
    '';

    services.v4l2-relayd.instances.ipu6 = {
      enable = lib.mkDefault true;

      cardLabel = lib.mkDefault "Intel MIPI Camera";

      extraPackages =
        with pkgs.gst_all_1;
        [ ]
        ++ lib.optional (cfg.platform == "ipu6") icamerasrc-ipu6
        ++ lib.optional (cfg.platform == "ipu6ep") icamerasrc-ipu6ep
        ++ lib.optional (cfg.platform == "ipu6epmtl") icamerasrc-ipu6epmtl;

      input = {
        pipeline = "icamerasrc";
        format = lib.mkIf (cfg.platform != "ipu6") (mkDefault "NV12");
      };
    };
  };
}
