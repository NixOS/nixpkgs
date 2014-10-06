{ config, pkgs, lib, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.e19;
  e19_enlightenment = pkgs.e19.enlightenment.override { set_freqset_setuid = true; };

in

{
  options = {

    services.xserver.desktopManager.e19.enable = mkOption {
      default = false;
      example = true;
      description = "Enable the E19 desktop environment.";
    };

  };

  config = mkIf (xcfg.enable && cfg.enable) {

    environment.systemPackages = [
      pkgs.e19.efl pkgs.e19.evas pkgs.e19.emotion pkgs.e19.elementary e19_enlightenment
      pkgs.e19.terminology pkgs.e19.econnman
      pkgs.xorg.xauth # used by kdesu
      pkgs.gtk # To get GTK+'s themes.
      pkgs.tango-icon-theme
      pkgs.shared_mime_info
      pkgs.gnome.gnomeicontheme
      pkgs.xorg.xcursorthemes
    ];

    environment.pathsToLink = [ "/etc/enlightenment" "/etc/xdg" "/share/enlightenment" "/share/elementary" "/share/applications" "/share/locale" "/share/icons" "/share/themes" "/share/mime" "/share/desktop-directories" ];

    services.xserver.desktopManager.session = [
    { name = "E19";
      start = ''
        # Set GTK_DATA_PREFIX so that GTK+ can find the themes
        export GTK_DATA_PREFIX=${config.system.path}
        # find theme engines
        export GTK_PATH=${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0
        export XDG_MENU_PREFIX=enlightenment

        # make available for D-BUS user services
        #export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}:${config.system.path}/share:${pkgs.e19.efl}/share

        # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
        ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update

        ${e19_enlightenment}/bin/enlightenment_start
        waitPID=$!
      '';
    }];

    security.setuidPrograms = [ "e19_freqset" ];

    environment.etc = singleton
      { source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
        target = "X11/xkb";
      };

    fonts.fonts = [ pkgs.dejavu_fonts pkgs.ubuntu_font_family ];

    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;

    #services.dbus.packages = [ pkgs.efl ]; # dbus-1 folder is not in /etc but in /share, so needs fixing first

    systemd.user.services.efreet =
      { enable = true;
        description = "org.enlightenment.Efreet";
        serviceConfig =
          { ExecStart = "${pkgs.e19.efl}/bin/efreetd";
            StandardOutput = "null";
          };
      };

    systemd.user.services.ethumb =
      { enable = true;
        description = "org.enlightenment.Ethumb";
        serviceConfig =
          { ExecStart = "${pkgs.e19.efl}/bin/ethumbd";
            StandardOutput = "null";
          };
      };


  };

}
