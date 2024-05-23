{ pkgs, lib, config, ... }:

with lib;

let cfg = config.programs.obs-studio;
in {
  options.programs.obs-studio = {
    enable = mkEnableOption "OBS Studio program";

    package = mkPackageOption pkgs "obs-studio" { example = "obs-studio"; };

    enableVirtualCamera = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Installs and sets up the v4l2loopback kernel module, necessary for OBS
        to start a virtual camera.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    boot = mkIf cfg.enableVirtualCamera {
      extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
    };

    security.polkit.enable = mkIf cfg.enableVirtualCamera true;
  };

  meta.maintainers = with lib.maintainers; [ CaptainJawZ ];
}
