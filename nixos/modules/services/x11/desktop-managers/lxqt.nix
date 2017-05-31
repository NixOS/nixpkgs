{ config, lib, pkgs, pkgs_multiarch, ... }:

with lib;

let

  # Remove packages of ys from xs, based on their names
  removePackagesByName = xs: ys:
    let
      pkgName = drv: (builtins.parseDrvName drv.name).name;
      ysNames = map pkgName ys;
    in
      filter (x: !(builtins.elem (pkgName x) ysNames)) xs;

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.lxqt;

in

{
  options = {

    services.xserver.desktopManager.lxqt.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the LXQt desktop manager";
    };

    environment.lxqt.excludePackages = mkOption {
      default = [];
      example = literalExample "[ pkgs.lxqt.qterminal ]";
      type = types.listOf types.package;
      description = "Which LXQt packages to exclude from the default environment";
    };

  };

  config = mkIf (xcfg.enable && cfg.enable) {

    services.xserver.desktopManager.session = singleton {
      name = "lxqt";
      bgSupport = true;
      start = ''
        exec ${pkgs.lxqt.lxqt-common}/bin/startlxqt
      '';
    };

    environment.systemPackages =
      pkgs.lxqt.preRequisitePackages ++
      pkgs.lxqt.corePackages ++
      (removePackagesByName
        pkgs.lxqt.optionalPackages
        config.environment.lxqt.excludePackages);

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink = [
      "/share/desktop-directories"
      "/share/icons"
      "/share/lxqt"
    ];

    libraries.packages = [ pkgs_multiarch.gvfs ];

  };

}
