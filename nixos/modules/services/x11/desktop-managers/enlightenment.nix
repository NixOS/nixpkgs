{ config, pkgs, lib, ... }:

with lib;

let

  e = pkgs.enlightenment;
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.enlightenment;
  GST_PLUGIN_PATH = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.gst-plugins-good
    pkgs.gst_all_1.gst-plugins-bad
    pkgs.gst_all_1.gst-libav ];

in

{
  options = {

    services.xserver.desktopManager.enlightenment.enable = mkOption {
      default = false;
      description = "Enable the Enlightenment desktop environment.";
    };

  };

  config = mkIf (xcfg.enable && cfg.enable) {

    environment.systemPackages = [
      e.efl e.enlightenment
      e.terminology e.econnman
      pkgs.xorg.xauth # used by kdesu
      pkgs.gtk2 # To get GTK+'s themes.
      pkgs.tango-icon-theme
      pkgs.shared_mime_info
      pkgs.gnome2.gnomeicontheme
      pkgs.xorg.xcursorthemes
    ];

    environment.pathsToLink = [
      "/etc/enlightenment" "/etc/xdg" "/share/enlightenment"
      "/share/elementary" "/share/applications" "/share/locale" "/share/icons"
      "/share/themes" "/share/mime" "/share/desktop-directories"
    ];

    services.xserver.desktopManager.session = [
    { name = "Enlightenment";
      start = ''
        export XDG_MENU_PREFIX=enlightenment

        export GST_PLUGIN_PATH="${GST_PLUGIN_PATH}"

        # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
        ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update

        exec ${e.enlightenment}/bin/enlightenment_start
      '';
    }];

    security.wrappers.e_freqset.source = "${e.enlightenment.out}/bin/e_freqset";

    environment.etc = singleton
      { source = xcfg.xkbDir;
        target = "X11/xkb";
      };

    fonts.fonts = [ pkgs.dejavu_fonts pkgs.ubuntu_font_family ];

    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;

    services.dbus.packages = [ e.efl ];

    systemd.user.services.efreet =
      { enable = true;
        description = "org.enlightenment.Efreet";
        serviceConfig =
          { ExecStart = "${e.efl}/bin/efreetd";
            StandardOutput = "null";
          };
      };

    systemd.user.services.ethumb =
      { enable = true;
        description = "org.enlightenment.Ethumb";
        serviceConfig =
          { ExecStart = "${e.efl}/bin/ethumbd";
            StandardOutput = "null";
          };
      };

  };

}
