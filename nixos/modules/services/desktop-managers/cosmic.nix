# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Lily Foster <lily@lily.flowers>
# Portions of this code are adapted from nixos-cosmic
# https://github.com/lilyinstarlight/nixos-cosmic

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.desktopManager.cosmic;
in
{
  meta.maintainers = lib.teams.cosmic.members;

  options = {
    services.desktopManager.cosmic = {
      enable = lib.mkEnableOption "Enable the COSMIC desktop environment";

      xwayland.enable = lib.mkEnableOption "Xwayland support for the COSMIC compositor" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Environment packages
    environment.pathsToLink = [
      "/share/backgrounds"
      "/share/cosmic"
    ];
    environment.systemPackages =
      with pkgs;
      [
        adwaita-icon-theme
        alsa-utils
        cosmic-applets
        cosmic-applibrary
        cosmic-bg
        cosmic-comp
        cosmic-edit
        cosmic-files
        config.services.displayManager.cosmic-greeter.package
        cosmic-icons
        cosmic-idle
        cosmic-launcher
        cosmic-notifications
        cosmic-osd
        cosmic-panel
        cosmic-player
        cosmic-randr
        cosmic-screenshot
        cosmic-session
        cosmic-settings
        cosmic-settings-daemon
        cosmic-term
        cosmic-wallpapers
        cosmic-workspaces-epoch
        hicolor-icon-theme
        playerctl
        pop-icon-theme
        pop-launcher
        xdg-user-dirs
      ]
      ++ lib.optionals cfg.xwayland.enable [
        xwayland
      ]
      ++ lib.optionals config.services.flatpak.enable [
        cosmic-store
      ];

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
    services.libinput.enable = true;
    services.upower.enable = true;
    # Required for screen locker
    security.pam.services.cosmic-greeter = { };

    # Fix for https://github.com/pop-os/cosmic-settings/issues/1154
    services.geoclue2.enable = true;
    services.geoclue2.enableDemoAgent = lib.mkDefault false; # No need to enable the demo agent to fix the bug; only the geoclue2 service needs to run

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
  };
}
