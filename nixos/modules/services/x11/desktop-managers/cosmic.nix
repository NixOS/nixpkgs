{ config, pkgs, lib, ... }:

let
  cfg = config.services.xserver.desktopManager.cosmic;
in
{
  meta.maintainers = with lib.maintainers; [ nyanbinary ];

  options.services.xserver.desktopManager.cosmic = {
    enable = lib.mkEnableOption (lib.mdDoc "COSMIC desktop environment");
  };

  config = lib.mkIf cfg.enable {
    # seed configuration in nixos-generate-config
    system.nixos-generate-config.desktopConfiguration = [
      ''
        # Enable the COSMIC Desktop Environment.
        services.xserver.displayManager.cosmic-greeter.enable = true;
        services.xserver.desktopManager.cosmic.enable = true;
      ''
    ];

    # environment packages
    environment.pathsToLink = [ "/share/cosmic" ];
    environment.systemPackages = with pkgs; [
      gnome.adwaita-icon-theme
      cosmic-applibrary
      cosmic-applets
      cosmic-bg
      cosmic-comp
      cosmic-edit
      cosmic-files
      cosmic-greeter
      cosmic-icons
      cosmic-launcher
      cosmic-notifications
      cosmic-osd
      cosmic-panel
      cosmic-randr
      cosmic-screenshot
      cosmic-session
      cosmic-settings
      cosmic-settings-daemon
      cosmic-term
      cosmic-workspaces-epoch
      hicolor-icon-theme
      pop-icon-theme
      pop-launcher
    ];

    # xdg portal packages and config
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-cosmic
        xdg-desktop-portal-gtk
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-cosmic
      ];
    };

    # fonts
    fonts.packages = with pkgs; [
      fira-mono
    ];

    # required features
    hardware.opengl.enable = true;
    services.xserver.libinput.enable = true;

    # optional features
    hardware.pulseaudio.enable = lib.mkDefault true;

    # required dbus services
    services.upower.enable = true;
    security.polkit.enable = true;

    # session packages
    services.xserver.displayManager.sessionPackages = with pkgs; [ cosmic-session ];
    systemd.packages = with pkgs; [ cosmic-session ];

    # required for screen locker
    security.pam.services.cosmic-greeter = { };
  };
}
