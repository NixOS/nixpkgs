{ config, pkgs, ... }:

with pkgs.lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.xfce;

in

{
  options = {

    services.xserver.desktopManager.xfce.enable = mkOption {
      default = false;
      example = true;
      description = "Enable the Xfce desktop environment.";
    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    services.xserver.desktopManager.session = singleton
      { name = "xfce";
        bgSupport = true;
        start =
          ''
            # Set GTK_PATH so that GTK+ can find the theme engines.
            export GTK_PATH=${config.system.path}/lib/gtk-2.0

            # Set GTK_DATA_PREFIX so that GTK+ can find the Xfce themes.
            export GTK_DATA_PREFIX=${config.system.path}

            # Necessary to get xfce4-mixer to find GST's ALSA plugin.
            # Ugly.
            export GST_PLUGIN_PATH=${config.system.path}/lib

            exec ${pkgs.stdenv.shell} ${pkgs.xfce.xinitrc}
          '';
      };

    environment.systemPackages =
      [ pkgs.gtk # To get GTK+'s themes.
        pkgs.hicolor_icon_theme
        pkgs.shared_mime_info
        pkgs.which # Needed by the xfce's xinitrc script.
        pkgs.xfce.exo
        pkgs.xfce.gtk_xfce_engine
        pkgs.xfce.libxfcegui4 # For the icons.
        pkgs.xfce.mousepad
        pkgs.xfce.ristretto
        pkgs.xfce.terminal
        pkgs.xfce.thunar
        pkgs.xfce.xfce4icontheme
        pkgs.xfce.xfce4panel
        pkgs.xfce.xfce4session
        pkgs.xfce.xfce4settings
        pkgs.xfce.xfce4mixer
        pkgs.xfce.xfceutils
        pkgs.xfce.xfconf
        pkgs.xfce.xfdesktop
        pkgs.xfce.xfwm4
        # This supplies some "abstract" icons such as
        # "utilities-terminal" and "accessories-text-editor".
        pkgs.gnome.gnomeicontheme
        pkgs.desktop_file_utils
        pkgs.xfce.libxfce4ui
        pkgs.xfce.garcon
        pkgs.xfce.thunar_volman
        pkgs.xfce.gvfs
        pkgs.xfce.xfce4_appfinder
      ]
      ++ optional config.powerManagement.enable pkgs.xfce.xfce4_power_manager;

    environment.pathsToLink =
      [ "/share/xfce4" "/share/themes" "/share/mime" "/share/desktop-directories" ];

    environment.shellInit =
      ''
        export GIO_EXTRA_MODULES=${pkgs.xfce.gvfs}/lib/gio/modules
      '';

    # Enable helpful DBus services.
    services.udisks.enable = true;
    services.upower.enable = config.powerManagement.enable;

  };

}
