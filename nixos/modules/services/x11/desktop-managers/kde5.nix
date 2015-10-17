{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.kde5;
  xorg = pkgs.xorg;

  kf5 = pkgs.kf5_stable;
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

      phonon = {

        gstreamer = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Enable the GStreamer Phonon backend (recommended).";
          };
        };

        vlc = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Enable the VLC Phonon backend.";
          };
        };

      };

    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    warnings = optional config.services.xserver.desktopManager.kde4.enable
      "KDE 4 should not be enabled at the same time as KDE 5";

    services.xserver.desktopManager.session = singleton {
      name = "kde5";
      bgSupport = true;
      start = ''exec ${plasma5.plasma-workspace}/bin/startkde;'';
    };

    security.setuidOwners = singleton {
      program = "kcheckpass";
      source = "${plasma5.plasma-workspace}/lib/libexec/kcheckpass";
      owner = "root";
      group = "root";
      setuid = true;
    };

    environment.systemPackages =
      [
        pkgs.qt4 # qtconfig is the only way to set Qt 4 theme

        kf5.kinit
        kf5.kglobalaccel

        plasma5.breeze
        plasma5.kde-cli-tools
        plasma5.kdeplasma-addons
        plasma5.kgamma5
        plasma5.khelpcenter
        plasma5.khotkeys
        plasma5.kinfocenter
        plasma5.kmenuedit
        plasma5.kscreen
        plasma5.ksysguard
        plasma5.kwayland
        plasma5.kwin
        plasma5.kwrited
        plasma5.milou
        plasma5.oxygen
        plasma5.polkit-kde-agent
        plasma5.systemsettings

        plasma5.plasma-desktop
        plasma5.plasma-workspace
        plasma5.plasma-workspace-wallpapers

        kdeApps.dolphin
        kdeApps.konsole

        pkgs.hicolor_icon_theme

        plasma5.kde-gtk-config
        pkgs.orion # GTK theme, nearly identical to Breeze
      ]
      ++ lib.optional config.hardware.bluetooth.enable plasma5.bluedevil
      ++ lib.optional config.networking.networkmanager.enable plasma5.plasma-nm
      ++ lib.optional config.hardware.pulseaudio.enable plasma5.plasma-pa
      ++ lib.optional config.powerManagement.enable plasma5.powerdevil
      ++ lib.optionals cfg.phonon.gstreamer.enable
        [
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
        ]
      ++ lib.optionals cfg.phonon.vlc.enable
        [
          pkgs.phonon_qt5_backend_vlc
          pkgs.phonon_backend_vlc
        ];

    environment.pathsToLink = [ "/share" ];

    environment.etc = singleton {
      source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
      target = "X11/xkb";
    };

    environment.profileRelativeEnvVars =
      mkIf cfg.phonon.gstreamer.enable
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
