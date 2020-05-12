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
  imports = [
    (mkRenamedOptionModule [ "services" "xserver" "desktopManager" "e19" "enable" ] [ "services" "xserver" "desktopManager" "enlightenment" "enable" ])
  ];

  options = {

    services.xserver.desktopManager.enlightenment.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Enlightenment desktop environment.";
    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [
      e.efl e.enlightenment
      e.terminology e.econnman
      pkgs.xorg.xauth # used by kdesu
      pkgs.gtk2 # To get GTK's themes.
      pkgs.tango-icon-theme

      pkgs.gnome-icon-theme
      pkgs.xorg.xcursorthemes
    ];

    environment.pathsToLink = [
      "/etc/enlightenment"
      "/share/enlightenment"
      "/share/elementary"
      "/share/locale"
    ];

    services.xserver.desktopManager.session = [
    { name = "Enlightenment";
      start = ''
        export XDG_MENU_PREFIX=e-

        export GST_PLUGIN_PATH="${GST_PLUGIN_PATH}"

        # make available for D-BUS user services
        #export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}:${config.system.path}/share:${e.efl}/share

        # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
        ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update

        exec ${e.enlightenment}/bin/enlightenment_start
      '';
    }];

    security.wrappers = (import "${e.enlightenment}/e-wrappers.nix").security.wrappers;

    environment.etc."X11/xkb".source = xcfg.xkbDir;

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
