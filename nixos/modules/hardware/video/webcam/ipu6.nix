{ config, lib, pkgs, ... }:
let

  inherit (lib) mkDefault mkEnableOption mkIf mkOption optional types;

  cfg = config.hardware.ipu6;

in
{

  options.hardware.ipu6 = {

    enable = mkEnableOption "support for Intel IPU6/MIPI cameras";

    platform = mkOption {
      type = types.enum [ "ipu6" "ipu6ep" "ipu6epmtl" ];
      description = ''
        Choose the version for your hardware platform.

        Use `ipu6` for Tiger Lake, `ipu6ep` for Alder Lake or Raptor Lake,
        and `ipu6epmtl` for Meteor Lake.
      '';
    };

  };

  config = mkIf cfg.enable {

    # Module is upstream as of 6.10
    boot.extraModulePackages = with config.boot.kernelPackages;
      optional (kernelOlder "6.10") ipu6-drivers;

    hardware.firmware = with pkgs; [
      ipu6-camera-bins
      ivsc-firmware
    ];

    services.udev.extraRules = ''
      SUBSYSTEM=="intel-ipu6-psys", MODE="0660", GROUP="video"
    '';

    services.v4l2-relayd.instances.ipu6 = {
      enable = mkDefault true;

      cardLabel = mkDefault "Intel MIPI Camera";

      extraPackages = with pkgs.gst_all_1; [ ]
        ++ optional (cfg.platform == "ipu6") icamerasrc-ipu6
        ++ optional (cfg.platform == "ipu6ep") icamerasrc-ipu6ep
        ++ optional (cfg.platform == "ipu6epmtl") icamerasrc-ipu6epmtl;

      input = {
        pipeline = "icamerasrc";
        format = mkIf (cfg.platform != "ipu6") (mkDefault "NV12");
      };
    };
  };
}
