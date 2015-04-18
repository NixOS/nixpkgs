{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.kde5;
  xorg = pkgs.xorg;

  phononBackends = {
    gstreamer = [
      pkgs.phonon_backend_gstreamer
      pkgs.gst_all.gstreamer
      pkgs.gst_all.gstPluginsBase
      pkgs.gst_all.gstPluginsGood
      pkgs.gst_all.gstPluginsUgly
      pkgs.gst_all.gstPluginsBad
      pkgs.gst_all.gstFfmpeg # for mp3 playback
      pkgs.phonon_qt5_backend_gstreamer
      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-libav # for mp3 playback
    ];

    vlc = [
      pkgs.phonon_qt5_backend_vlc
      pkgs.phonon_backend_vlc
    ];
  };

  phononBackendPackages = flip concatMap cfg.phononBackends
    (name: attrByPath [name] (throw "unknown phonon backend `${name}'") phononBackends);

  kf5 = plasma5.kf5;

  plasma5 = pkgs.plasma5_stable;

  kdeApps = pkgs.kdeApps_stable;

in

{
  options = {

    services.xserver.desktopManager.kde5 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Plasma 5 (KDE 5) desktop environment.";
      };

      phononBackends = mkOption {
        type = types.listOf types.str;
        default = ["gstreamer"];
        example = ["gstreamer" "vlc"];
        description = ''
          Phonon backends to use in KDE. Only the VLC and GStreamer backends are
          available. The GStreamer backend is preferred by upstream.
        '';
      };

    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    warnings = optional config.services.xserver.desktopManager.kde4.enable
      "KDE 4 should not be enabled at the same time as KDE 5";

    services.xserver.desktopManager.session = singleton {
      name = "kde5";
      bgSupport = true;
      start = ''exec ${plasma5.startkde}/bin/startkde;'';
    };

    security.setuidOwners = singleton {
      program = "kcheckpass";
      source = "${plasma5.plasma-workspace}/lib/libexec/kcheckpass";
      owner = "root";
      group = "root";
      setuid = true;
    };

    environment.systemPackages =
      filter isDerivation (builtins.attrValues plasma5)
      ++ filter isDerivation (builtins.attrValues kf5)
      ++ [
        pkgs.qt4 # qtconfig is the only way to set Qt 4 theme

        kdeApps.kde-baseapps
        kdeApps.kde-base-artwork
        kdeApps.kmix
        kdeApps.konsole
        kdeApps.oxygen-icons

        kdeApps.kde-runtime

        pkgs.hicolor_icon_theme

        pkgs.orion # GTK theme, nearly identical to Breeze
      ] ++ phononBackendPackages;

    environment.pathsToLink = [ "/share" ];

    environment.etc = singleton {
      source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
      target = "X11/xkb";
    };

    environment.profileRelativeEnvVars =
      mkIf (lib.elem "gstreamer" cfg.phononBackends)
      {
        GST_PLUGIN_SYSTEM_PATH = [ "/lib/gstreamer-0.10" ];
        GST_PLUGIN_SYSTEM_PATH_1_0 = [ "/lib/gstreamer-1.0" ];
      };

    fonts.fonts = [ plasma5.oxygen-fonts ];

    programs.ssh.askPassword = "${plasma5.ksshaskpass}/bin/ksshaskpass";

    # Enable helpful DBus services.
    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;

    # Extra UDEV rules used by Solid
    services.udev.packages = [ pkgs.media-player-info ];

    security.pam.services.kde = { allowNullPassword = true; };

  };

}
