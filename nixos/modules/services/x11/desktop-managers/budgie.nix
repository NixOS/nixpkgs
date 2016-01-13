{ config, lib, pkgs, budgie, ... }:

with lib;

let
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.budgie;
  gnome3 = pkgs.gnome3_18;
in
{
  options = {
    services.xserver.desktopManager.budgie.enable = mkEnableOption "Budgie desktop environment";
  };

  config = mkIf (xcfg.enable && cfg.enable) {

    security.polkit.enable = true;
    services.udisks2.enable = true;
    services.gnome3.gvfs.enable = true;
    services.gnome3.sushi.enable = mkDefault true;
    services.gnome3.tracker.enable = mkDefault true;
    hardware.pulseaudio.enable = mkDefault true;
    services.telepathy.enable = mkDefault true;
    networking.networkmanager.enable = mkDefault true;
    services.upower.enable = config.powerManagement.enable;
    hardware.bluetooth.enable = mkDefault true;

    services.xserver.desktopManager.session = singleton {
      name = "budgie";
      bgSupport = true;
      start = ''
        # Set GTK_DATA_PREFIX so that GTK+ can find the themes
        export GTK_DATA_PREFIX=${config.system.path}

        # find theme engines
        export GTK_PATH=${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0

        # Let nautilus find extensions
        export NAUTILUS_EXTENSION_DIR=${config.system.path}/lib/nautilus/extensions-3.0/

        # Find the mouse
        export XCURSOR_PATH=~/.icons:${config.system.path}/share/icons

        # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
        ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update

        ${pkgs.budgie.budgie-desktop}/bin/budgie-desktop&
        waitPID=$!
      '';
    };

    environment.systemPackages = with gnome3; [
      pkgs.budgie.budgie-desktop pkgs.arc-gtk-theme pkgs.moka-icon-theme
      pkgs.desktop_file_utils pkgs.ibus pkgs.shared_mime_info glib gtk3
      glib_networking gvfs dconf gnome-backgrounds gnome_control_center
      gnome-menus gnome_settings_daemon gnome_themes_standard defaultIconTheme
      pkgs.hicolor_icon_theme empathy eog epiphany evince nautilus totem
      gnome-calculator gnome-screenshot gnome-system-monitor gnome_terminal
      file-roller gedit ];

    environment.pathsToLink = [ "/share" ];
  };

}
