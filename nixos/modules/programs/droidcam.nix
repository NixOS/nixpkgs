{ lib, pkgs, config, ... }:

with lib;

{
  options.services.droidcam = {
    enable = mkEnableOption "DroidCam client";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.droidcam ];

    boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    boot.kernelModules = [ "v4l2loopback" "snd-aloop" ];
  };
}
