{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.desktopManager;

in

{
  options = {

    services.xserver.desktopManager.select = mkOption {
      type = with types; listOf (enum [ "lumina" ]);
    };

  };

  config = mkIf (elem "lumina" dmcfg.select) {

    services.xserver.desktopManager.session = singleton {
      name = "lumina";
      start = ''
        exec ${pkgs.lumina}/bin/start-lumina-desktop
      '';
    };

    environment.systemPackages = [
      pkgs.fluxbox
      pkgs.libsForQt5.kwindowsystem
      pkgs.kdeFrameworks.oxygen-icons5
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
