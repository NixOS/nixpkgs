{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.herbstluftwm;
in

{
  options = {
    services.xserver.windowManager.herbstluftwm.enable = mkEnableOption "herbstluftwm";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "herbstluftwm";
      start = "
        ${pkgs.herbstluftwm}/bin/herbstluftwm
      ";
    };
    environment.systemPackages = [ pkgs.herbstluftwm ];
  };
}
