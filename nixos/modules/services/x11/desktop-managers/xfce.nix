{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.xfce;

in

{
  options = {

    services.xserver.desktopManager.xfce = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Xfce desktop environment.";
      };

      thunarPlugins = mkOption {
        default = [];
        type = types.listOf types.package;
        example = literalExample "[ pkgs.xfce.thunar-archive-plugin ]";
        description = ''
          A list of plugin that should be installed with Thunar.
        '';
      };

      noDesktop = mkOption {
        type = types.bool;
        default = false;
        description = "Don't install XFCE desktop components (xfdesktop, panel and notification daemon).";
      };

      extraSessionCommands = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Shell commands executed just before XFCE is started.
        '';
      };
    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    services.xserver.desktopManager.session = singleton
      { name = "xfce";
        bgSupport = true;
        start =
          ''
            ${cfg.extraSessionCommands}

            # Set GTK_PATH so that GTK+ can find the theme engines.
            export GTK_PATH="${config.system.path}/lib/gtk-2.0:${config.system.path}/lib/gtk-3.0"

            # Set GTK_DATA_PREFIX so that GTK+ can find the Xfce themes.
            export GTK_DATA_PREFIX=${config.system.path}

            ${pkgs.stdenv.shell} ${pkgs.xfce.xinitrc} &
            waitPID=$!
          '';
      };

    services.xserver.updateDbusEnvironment = true;

    environment.systemPackages =
      [ pkgs.gtk # To get GTK+'s themes.
        pkgs.hicolor_icon_theme
        pkgs.tango-icon-theme
        pkgs.shared_mime_info
        pkgs.which # Needed by the xfce's xinitrc script.
        pkgs.xfce.exo
        pkgs.xfce.gtk_xfce_engine
        pkgs.xfce.mousepad
        pkgs.xfce.ristretto
        pkgs.xfce.terminal
       (pkgs.xfce.thunar.override { thunarPlugins = cfg.thunarPlugins; })
        pkgs.xfce.xfce4icontheme
        pkgs.xfce.xfce4session
        pkgs.xfce.xfce4settings
        pkgs.xfce.xfce4mixer
        pkgs.xfce.xfce4volumed
        pkgs.xfce.xfce4-screenshooter
        pkgs.xfce.xfconf
        pkgs.xfce.xfwm4
        # This supplies some "abstract" icons such as
        # "utilities-terminal" and "accessories-text-editor".
        pkgs.gnome3.defaultIconTheme
        pkgs.desktop_file_utils
        pkgs.xfce.libxfce4ui
        pkgs.xfce.garcon
        pkgs.xfce.thunar_volman
        pkgs.xfce.gvfs
        pkgs.xfce.xfce4_appfinder
        pkgs.xfce.tumbler       # found via dbus
      ]
      ++ optional config.powerManagement.enable pkgs.xfce.xfce4_power_manager
      ++ optionals (!cfg.noDesktop)
         [ pkgs.xfce.xfce4panel
           pkgs.xfce.xfdesktop
	   pkgs.xfce.xfce4notifyd  # found via dbus
         ];

    environment.pathsToLink =
      [ "/share/xfce4" "/share/themes" "/share/mime" "/share/desktop-directories" "/share/gtksourceview-2.0" ];

    environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.xfce.gvfs}/lib/gio/modules" ];

    # Enable helpful DBus services.
    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;

  };

}
