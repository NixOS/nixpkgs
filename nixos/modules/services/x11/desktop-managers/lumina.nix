{
  config,
  lib,
  pkgs,
  ...
}:
let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.lumina;

in

{
  meta = {
    maintainers = lib.teams.lumina.members;
  };

  options = {

    services.xserver.desktopManager.lumina.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Lumina desktop manager";
    };

  };

  config = lib.mkIf cfg.enable {

    services.displayManager.sessionPackages = [
      pkgs.lumina.lumina
    ];

    environment.systemPackages = pkgs.lumina.preRequisitePackages ++ pkgs.lumina.corePackages;

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink = [
      "/share/lumina"
      # FIXME: modules should link subdirs of `/share` rather than relying on this
      "/share"
    ];

  };
}
