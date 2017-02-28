{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.lumina;

in

{
  options = {

    services.xserver.desktopManager.lumina.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Lumina desktop manager";
    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    services.xserver.desktopManager.session = singleton {
      name = "lumina";
      start = ''
        exec ${pkgs.lumina}/bin/start-lumina-desktop
      '';
    };

    environment.systemPackages = [
      pkgs.fluxbox
      pkgs.qt5.kwindowsystem
      pkgs.qt5.oxygen-icons5
      pkgs.lumina
      pkgs.numlockx
      pkgs.qt5.qtsvg
      pkgs.xscreensaver
    ];

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink = [
      "/share/desktop-directories"
      "/share/icons"
      "/share/lumina"
      "/share"
    ];

  };
}
