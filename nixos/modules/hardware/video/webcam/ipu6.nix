{ config, lib, pkgs, ... }:
let

  inherit (lib) mkDefault mkEnableOption mkIf mkOption optional types;

  cfg = config.hardware.ipu6;

in
{

  options.hardware.ipu6 = {

    enable = mkEnableOption (lib.mdDoc "support for Intel IPU6/MIPI cameras");

    platform = mkOption {
      type = types.enum [ "ipu6" "ipu6ep" ];
      description = lib.mdDoc ''
        Choose the version for your hardware platform.

        Use `ipu6` for Tiger Lake and `ipu6ep` for Alder Lake respectively.
      '';
    };

  };

  config = mkIf cfg.enable {

    boot.extraModulePackages = with config.boot.kernelPackages; [
      ipu6-drivers
    ];

    hardware.firmware = with pkgs; [ ]
      ++ optional (cfg.platform == "ipu6") ipu6-camera-bin
      ++ optional (cfg.platform == "ipu6ep") ipu6ep-camera-bin;

    services.udev.extraRules = ''
      SUBSYSTEM=="intel-ipu6-psys", MODE="0660", GROUP="video"
    '';

    services.v4l2-relayd.instances.ipu6 = {
      enable = mkDefault true;

      cardLabel = mkDefault "Intel MIPI Camera";

      extraPackages = with pkgs.gst_all_1; [ ]
        ++ optional (cfg.platform == "ipu6") icamerasrc-ipu6
        ++ optional (cfg.platform == "ipu6ep") icamerasrc-ipu6ep;

      input = {
        pipeline = "icamerasrc";
        format = mkIf (cfg.platform == "ipu6ep") (mkDefault "NV12");
      };
    };

  };

}
