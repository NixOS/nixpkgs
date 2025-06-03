# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Lily Foster <lily@lily.flowers>
# Portions of this code are adapted from nixos-cosmic
# https://github.com/lilyinstarlight/nixos-cosmic

{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.desktopManager.cosmic;
  excludedCorePkgs = lib.lists.intersectLists corePkgs config.environment.cosmic.excludePackages;
  # **ONLY ADD PACKAGES WITHOUT WHICH COSMIC CRASHES, NOTHING ELSE**
  corePkgs =
    with pkgs;
    [
      cosmic-applets
      cosmic-applibrary
      cosmic-bg
      cosmic-comp
      cosmic-files
      config.services.displayManager.cosmic-greeter.package
      cosmic-idle
      cosmic-launcher
      cosmic-notifications
      cosmic-osd
      cosmic-panel
      cosmic-session
      cosmic-settings
      cosmic-settings-daemon
      cosmic-workspaces-epoch
    ]
    ++ lib.optionals cfg.xwayland.enable [
      # Why would you want to enable XWayland but exclude the package
      # providing XWayland support? Doesn't make sense. Add `xwayland` to the
      # `corePkgs` list.
      xwayland
    ];
in
{
  meta.maintainers = lib.teams.cosmic.members;

  options = {
    services.desktopManager.cosmic = {
      enable = lib.mkEnableOption "Enable the COSMIC desktop environment";

      showExcludedPkgsWarning = lib.mkEnableOption "Disable the warning for excluding core packages." // {
        default = true;
      };

      xwayland.enable = lib.mkEnableOption "Xwayland support for the COSMIC compositor" // {
        default = true;
      };
    };

    environment.cosmic.excludePackages = lib.mkOption {
      description = "List of packages to exclude from the COSMIC environment.";
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.cosmic-player ]";
    };
  };

  config = lib.mkIf cfg.enable {
    # Environment packages
    environment.pathsToLink = [
      "/share/backgrounds"
      "/share/cosmic"
    ];
    environment.systemPackages = utils.removePackagesByName (
      corePkgs
      ++ (
        with pkgs;
        [
          adwaita-icon-theme
          alsa-utils
          cosmic-edit
          cosmic-icons
          cosmic-player
          cosmic-randr
          cosmic-screenshot
          cosmic-term
          cosmic-wallpapers
          hicolor-icon-theme
          playerctl
          pop-icon-theme
          pop-launcher
          xdg-user-dirs
        ]
        ++ lib.optionals config.services.flatpak.enable [
          # User may have Flatpaks enabled but might not want the `cosmic-store` package.
          cosmic-store
        ]
      )
    ) config.environment.cosmic.excludePackages;

    # Distro-wide defaults for graphical sessions
    services.graphical-desktop.enable = true;

    xdg = {
      icons.fallbackCursorThemes = lib.mkDefault [ "Cosmic" ];

      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-cosmic
          xdg-desktop-portal-gtk
        ];
        configPackages = lib.mkDefault [ pkgs.xdg-desktop-portal-cosmic ];
      };
    };

    systemd = {
      packages = [ pkgs.cosmic-session ];
      user.targets = {
        # TODO: remove when upstream has XDG autostart support
        cosmic-session = {
          wants = [ "xdg-desktop-autostart.target" ];
          before = [ "xdg-desktop-autostart.target" ];
        };
      };
    };

    fonts.packages = with pkgs; [
      fira
      noto-fonts
      open-sans
    ];

    # Required options for the COSMIC DE
    environment.sessionVariables.X11_BASE_RULES_XML = "${config.services.xserver.xkb.dir}/rules/base.xml";
    environment.sessionVariables.X11_EXTRA_RULES_XML = "${config.services.xserver.xkb.dir}/rules/base.extras.xml";
    programs.dconf.enable = true;
    programs.dconf.packages = [ pkgs.cosmic-session ];
    security.polkit.enable = true;
    security.rtkit.enable = true;
    services.accounts-daemon.enable = true;
    services.displayManager.sessionPackages = [ pkgs.cosmic-session ];
    services.geoclue2.enable = true;
    services.geoclue2.enableDemoAgent = false;
    services.libinput.enable = true;
    services.upower.enable = true;
    # Required for screen locker
    security.pam.services.cosmic-greeter = { };

    # Good to have defaults
    hardware.bluetooth.enable = lib.mkDefault true;
    networking.networkmanager.enable = lib.mkDefault true;
    services.acpid.enable = lib.mkDefault true;
    services.avahi.enable = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = lib.mkDefault true;
    services.gvfs.enable = lib.mkDefault true;
    services.power-profiles-daemon.enable = lib.mkDefault (
      !config.hardware.system76.power-daemon.enable
    );

    warnings = lib.optionals (cfg.showExcludedPkgsWarning && excludedCorePkgs != [ ]) [
      ''
        The `environment.cosmic.excludePackages` option was used to exclude some
        packages from the environment which also includes some packages that the
        maintainers of the COSMIC DE deem necessary for the COSMIC DE to start
        and initialize. Excluding said packages creates a high probability that
        the COSMIC DE will fail to initialize properly, or completely. This is an
        unsupported use case. If this was not intentional, please assign an empty
        list to the `environment.cosmic.excludePackages` option. If you want to
        exclude non-essential packages, please look at the NixOS module for the
        COSMIC DE and look for the essential packages in the `corePkgs` list.

        You can stop this warning from appearing by setting the option
        `services.desktopManager.cosmic.showExcludedPkgsWarning` to `false`.
      ''
    ];
  };
}
