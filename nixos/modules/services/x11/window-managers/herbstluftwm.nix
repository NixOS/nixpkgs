{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.xserver.windowManager.herbstluftwm;
in

{
  options = {
    services.xserver.windowManager.herbstluftwm.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable the herbstluftwm window manager.";
    };
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
