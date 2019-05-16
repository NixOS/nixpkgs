{ config, lib, pkgs, ... }:

with lib;

let
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
        # Upstream installs default configuration files in
        # $prefix/share/lxqt instead of $prefix/etc/xdg, (arguably)
        # giving distributors freedom to ship custom default
        # configuration files more easily. In order to let the session
        # manager find them the share subdirectory is added to the
        # XDG_CONFIG_DIRS environment variable.
        #
        # For an explanation see
        # https://github.com/lxqt/lxqt/issues/1521#issuecomment-405097453
        #
        export XDG_CONFIG_DIRS=$XDG_CONFIG_DIRS''${XDG_CONFIG_DIRS:+:}${config.system.path}/share

        exec ${pkgs.lxqt.lxqt-session}/bin/startlxqt
      '';
    };

    environment.systemPackages =
      pkgs.lxqt.preRequisitePackages ++
      pkgs.lxqt.corePackages ++
      (pkgs.gnome3.removePackagesByName
        pkgs.lxqt.optionalPackages
        config.environment.lxqt.excludePackages);

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink = [ "/share" ];

    environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.gvfs}/lib/gio/modules" ];

    services.upower.enable = config.powerManagement.enable;
  };

}
