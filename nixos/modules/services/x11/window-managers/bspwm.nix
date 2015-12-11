{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.bspwm;
in

{
  options = {
    services.xserver.windowManager.bspwm.enable = mkEnableOption "bspwm";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "bspwm";
      start = "
        ${pkgs.sxhkd}/bin/sxhkd &
        ${pkgs.bspwm}/bin/bspwm
      ";
    };
    environment.systemPackages = [ pkgs.bspwm ];
  };
}
