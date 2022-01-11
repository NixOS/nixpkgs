{ lib, pkgs, config, ... }:

with lib;

{
  options.programs.droidcam = {
    enable = mkEnableOption "DroidCam client";
  };

  config = lib.mkIf config.programs.droidcam.enable {
    environment.systemPackages = [ pkgs.droidcam ];

    boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    boot.kernelModules = [ "v4l2loopback" "snd-aloop" ];
  };
}
