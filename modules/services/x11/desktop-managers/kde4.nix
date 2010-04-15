{ config, pkgs, ... }:

with pkgs.lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.kde4;
  xorg = pkgs.xorg;

in

{

  imports = [ ./kde-environment.nix ];

    
  options = {

    services.xserver.desktopManager.kde4.enable = mkOption {
      default = false;
      example = true;
      description = "Enable the KDE 4 desktop environment.";
    };

  };

  
  config = mkIf (xcfg.enable && cfg.enable) {

    # If KDE 4 is enabled, make it the default desktop manager (unless
    # overriden by the user's configuration).
    # !!! doesn't work yet ("Multiple definitions. Only one is allowed
    # for this option.")
    # services.xserver.desktopManager.default = mkOverride 900 "kde4";

    services.xserver.desktopManager.session = singleton
      { name = "kde4";
        bgSupport = true;
        start =
          ''
            # Start KDE.
            exec ${pkgs.kde4.kdebase_workspace}/bin/startkde
          '';
      };

    security.setuidPrograms = [ "kcheckpass" ];

    environment.kdePackages =
      [ pkgs.kde4.kdelibs
        pkgs.kde4.kdebase
        pkgs.kde4.kdebase_runtime
        pkgs.kde4.kdebase_workspace
        pkgs.shared_mime_info
        pkgs.gst_all.gstreamer
        pkgs.gst_all.gstPluginsBase
        pkgs.gst_all.gstPluginsGood
      ] ++ optional (pkgs.kde4 ? oxygen_icons) pkgs.kde4.oxygen_icons;

    environment.x11Packages =
      [ xorg.xmessage # so that startkde can show error messages
        pkgs.kde4.qt4 # needed for qdbus
        xorg.xset # used by startkde, non-essential
      ];

    environment.etc = singleton
      { source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
        target = "X11/xkb";
      };

  };

}
