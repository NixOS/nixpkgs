{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

with lib;

let
  cfg = config.services.xserver.desktopManager.lxqt;

in

{
  meta = {
    maintainers = teams.lxqt.members;
  };

  options = {

    services.xserver.desktopManager.lxqt.enable = mkEnableOption "the LXQt desktop manager";

    services.xserver.desktopManager.lxqt.enableWaylandSession =
      mkEnableOption "the experimental LXQt Wayland session";

    services.xserver.desktopManager.lxqt.iconThemePackage =
      lib.mkPackageOption pkgs [ "kdePackages" "breeze-icons" ] { }
      // {
        description = "The package that provides a default icon theme.";
      };

    services.xserver.desktopManager.lxqt.extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = with pkgs; [
        openbox
        lxqt.obconf-qt
      ];
      defaultText = lib.literalExpression "with pkgs; [ openbox lxqt.obconf-qt ]";
      example = lib.literalExpression "with pkgs; [ xscreensaver ]";
      description = "Extra packages to be installed system wide.";
    };

    environment.lxqt.excludePackages = mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      defaultText = lib.literalExpression "[ ]";
      example = lib.literalExpression "with pkgs; [ lxqt.qterminal lxqt.screengrab ]";
      description = "Which LXQt packages to exclude from the default environment";
    };

  };

  config = mkIf cfg.enable {

    services.xserver.desktopManager.session =
      let
        lxqtSession =
          if cfg.enableWaylandSession then
            "${pkgs.lxqt.lxqt-wayland-session}/bin/startlxqtwayland"
          else
            "${pkgs.lxqt.lxqt-session}/bin/startlxqt";
      in
      singleton {
        name = "lxqt";
        prettyName = "LXQt Session";
        desktopNames = [ "LXQt " ];
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

          exec ${lxqtSession}
        '';
      };

    environment.systemPackages =
      pkgs.lxqt.preRequisitePackages
      ++ pkgs.lxqt.corePackages
      ++ optionals cfg.enableWaylandSession [
        pkgs.kdePackages.layer-shell-qt
        pkgs.lxqt.lxqt-wayland-session
        pkgs.qt6.qtwayland

        # used in the default sway configuration for LXQt
        pkgs.libnotify
        pkgs.swaybg
        pkgs.swayidle
      ]
      ++ [
        cfg.iconThemePackage
      ]
      ++ (utils.removePackagesByName pkgs.lxqt.optionalPackages config.environment.lxqt.excludePackages)
      ++ cfg.extraPackages;

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink = [ "/share" ];

    programs.gnupg.agent.pinentryPackage = mkDefault pkgs.pinentry-qt;

    # virtual file systems support for PCManFM-QT
    services.gvfs.enable = mkDefault true;

    services.upower.enable = config.powerManagement.enable;

    services.libinput.enable = mkDefault true;

    xdg.portal.lxqt.enable = mkDefault true;

    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1050804
    xdg.portal.config.lxqt.default = mkDefault [
      "lxqt"
      "gtk"
    ];

    programs.labwc.enable = mkDefault (cfg.enableWaylandSession);
  };

}
