{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.deepin;

in

{
  options = {

    services.xserver.desktopManager.deepin.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Deepin Desktop Environment";
    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    services.xserver.displayManager.sessionPackages = [ pkgs.deepin.startdde ];
    services.xserver.displayManager.defaultSession = mkForce "deepin";

    hardware.bluetooth.enable = mkDefault true;
    hardware.pulseaudio.enable = mkDefault true;
    security.polkit.enable = true;
    services.accounts-daemon.enable = true;
    services.bamf.enable = true;
    services.deepin.core.enable = true;
    services.gnome3.at-spi2-core.enable = true;
    services.gnome3.glib-networking.enable = true;
    services.gnome3.gnome-keyring.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;
    services.xserver.libinput.enable = mkDefault true;
    services.xserver.updateDbusEnvironment = true;

    networking.networkmanager.enable = true;

    fonts.fonts = with pkgs; [ noto-fonts ];

    environment.systemPackages = with pkgs; [
      deepin.dde-calendar
      deepin.dde-daemon
      (deepin.dde-dock.override { plugins = [ deepin.dde-file-manager ]; })
      deepin.dde-kwin
      deepin.dde-file-manager
      deepin.dde-launcher
      deepin.dde-polkit-agent
      deepin.dde-session-shell
      deepin.dde-session-ui
      deepin.deepin-desktop-base
      deepin.deepin-gtk-theme
      deepin.deepin-icon-theme
      deepin.deepin-image-viewer
      deepin.deepin-movie-reborn
      deepin.deepin-screen-recorder
      deepin.deepin-shortcut-viewer
      deepin.deepin-sound-theme
      deepin.deepin-terminal
      deepin.deepin-wallpapers
      deepin.dpa-ext-gnomekeyring
      deepin.qt5integration
      deepin.qt5platform-plugins
      deepin.startdde
    ];

    environment.variables.DDE_POLKIT_PLUGINS_DIRS = [ "${config.system.path}/lib/polkit-1-dde/plugins" ];

    environment.variables.NIX_GSETTINGS_OVERRIDES_DIR = [
      "${pkgs.deepin.deepin-desktop-schemas}/share/gsettings-schemas/${pkgs.deepin.deepin-desktop-schemas.name}/glib-2.0/schemas"
    ];

    # Link some extra directories in /run/current-system/sw/share
    environment.pathsToLink = [
      "/lib/polkit-1-dde/plugins"
      "/share"
    ];
  };
}
