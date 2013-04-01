{ config, pkgs, ... }:

with pkgs.lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.e17;

in

{
  options = {

    services.xserver.desktopManager.e17.enable = mkOption {
      default = false;
      example = true;
      description = "Enable support for the E17 desktop environment.";
    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    services.dbus.packages = [ pkgs.e17.ethumb ];

  };

}
