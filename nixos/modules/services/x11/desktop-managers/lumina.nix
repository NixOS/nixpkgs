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


  config = mkIf cfg.enable {

    services.xserver.desktopManager.session = singleton {
      name = "lumina";
      start = ''
        exec ${pkgs.lumina.lumina}/bin/start-lumina-desktop
      '';
    };

    environment.systemPackages =
      pkgs.lumina.preRequisitePackages ++
      pkgs.lumina.corePackages;

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink = [
      "/share/lumina"
      # FIXME: modules should link subdirs of `/share` rather than relying on this
      "/share"
    ];

  };
}
