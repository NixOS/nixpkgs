{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
  cfg = wmcfg.herbstluftwm;
in

{
  config = mkIf (elem "herbstluftwm" wmcfg.enable) {
    services.xserver.windowManager.session = singleton {
      name = "herbstluftwm";
      start = "
        ${pkgs.herbstluftwm}/bin/herbstluftwm
      ";
    };
    environment.systemPackages = [ pkgs.herbstluftwm ];
  };
}
