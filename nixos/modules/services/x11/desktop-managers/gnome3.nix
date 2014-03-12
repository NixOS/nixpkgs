{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.xserver.desktopManager.gnome3;
  gnome3 = pkgs.gnome3;
in {

  options = {

    services.xserver.desktopManager.gnome3.enable = mkOption {
      default = false;
      example = true;
      description = "Enable Gnome 3 desktop manager.";
    };

  };

  config = mkIf cfg.enable {

    # Enable helpful DBus services.
    security.polkit.enable = true;
    services.udisks2.enable = true;
    networking.networkmanager.enable = true;
    services.upower.enable = config.powerManagement.enable;

    fonts.extraFonts = [ pkgs.dejavu_fonts ];

    services.xserver.desktopManager.session = singleton
      { name = "gnome3";
        start = ''
          # Set GTK_DATA_PREFIX so that GTK+ can find the themes
          export GTK_DATA_PREFIX=${config.system.path}

          # find theme engines
          export GTK_PATH=${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0

          export XDG_MENU_PREFIX=gnome

          ${gnome3.gnome_session}/bin/gnome-session&
          waitPID=$!
        '';
      };

    environment.variables.GIO_EXTRA_MODULES = [ "${gnome3.dconf}/lib/gio/modules" ];
    environment.systemPackages =
      [ gnome3.evince
        gnome3.eog
        gnome3.dconf
        gnome3.vino
        gnome3.epiphany
        gnome3.baobab
        gnome3.gucharmap
        gnome3.nautilus
        gnome3.yelp
        pkgs.ibus
        gnome3.gnome_shell
        gnome3.gnome_settings_daemon
        gnome3.gnome_terminal
        gnome3.gnome_icon_theme
        gnome3.gnome_themes_standard
        gnome3.gnome_control_center
      ];
  };


}
