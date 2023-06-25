{ lib, pkgs, config, ... }:

with lib;

{
  options.programs.droidcam = {
    enable = mkEnableOption (lib.mdDoc "DroidCam client");
  };

  config = lib.mkIf config.programs.droidcam.enable {
    environment.systemPackages = [ pkgs.droidcam ];

    boot.extraModulePackages = [ config.boot.kernel.packages.v4l2loopback ];
    boot.kernel.modules = [ "v4l2loopback" "snd-aloop" ];
  };
}
