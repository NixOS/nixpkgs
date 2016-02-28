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
        SXHKD_SHELL=/bin/sh ${pkgs.sxhkd}/bin/sxhkd -f 100 &
        ${pkgs.bspwm}/bin/bspwm
      ";
    };
    environment.systemPackages = [ pkgs.bspwm ];
  };
}
