{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.kde5;
  xorg = pkgs.xorg;

  kde5 = pkgs.kde5;

in

{
  options = {

    services.xserver.desktopManager.kde5 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Plasma 5 (KDE 5) desktop environment.";
      };

      enableQt4Support = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable support for Qt 4-based applications. Particularly, install the
          Qt 4 version of the Breeze theme and a default backend for Phonon.
        '';
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = ''
          KDE packages that need to be installed system-wide.
        '';
      };

    };

  };


  config = mkMerge [
    (mkIf (cfg.extraPackages != []) {
      environment.systemPackages = [ (kde5.kdeWrapper cfg.extraPackages) ];
    })

    (mkIf (xcfg.enable && cfg.enable) {
      services.xserver.desktopManager.session = singleton {
        name = "kde5";
        bgSupport = true;
        start = ''
          # Load PulseAudio module for routing support.
          # See http://colin.guthr.ie/2009/10/so-how-does-the-kde-pulseaudio-support-work-anyway/
          ${optionalString config.hardware.pulseaudio.enable ''
            ${getBin config.hardware.pulseaudio.package}/bin/pactl load-module module-device-manager "do_routing=1"
          ''}

          exec "${kde5.startkde}"
        '';
      };

      security.wrappers = {
        kcheckpass.source = "${kde5.plasma-workspace.out}/lib/libexec/kcheckpass";
        "start_kdeinit".source = "${kde5.kinit.out}/lib/libexec/kf5/start_kdeinit";
      };

      environment.systemPackages =
        [
          kde5.frameworkintegration
          kde5.kactivities
          kde5.kauth
          kde5.kcmutils
          kde5.kconfig
          kde5.kconfigwidgets
          kde5.kcoreaddons
          kde5.kdbusaddons
          kde5.kdeclarative
          kde5.kded
          kde5.kdesu
          kde5.kdnssd
          kde5.kemoticons
          kde5.kfilemetadata
          kde5.kglobalaccel
          kde5.kguiaddons
          kde5.kiconthemes
          kde5.kidletime
          kde5.kimageformats
          kde5.kinit
          kde5.kio
          kde5.kjobwidgets
          kde5.knewstuff
          kde5.knotifications
          kde5.knotifyconfig
          kde5.kpackage
          kde5.kparts
          kde5.kpeople
          kde5.krunner
          kde5.kservice
          kde5.ktextwidgets
          kde5.kwallet
          kde5.kwallet-pam
          kde5.kwalletmanager
          kde5.kwayland
          kde5.kwidgetsaddons
          kde5.kxmlgui
          kde5.kxmlrpcclient
          kde5.plasma-framework
          kde5.solid
          kde5.sonnet
          kde5.threadweaver

          kde5.breeze-qt5
          kde5.kactivitymanagerd
          kde5.kde-cli-tools
          kde5.kdecoration
          kde5.kdeplasma-addons
          kde5.kgamma5
          kde5.khotkeys
          kde5.kinfocenter
          kde5.kmenuedit
          kde5.kscreen
          kde5.kscreenlocker
          kde5.ksysguard
          kde5.kwayland
          kde5.kwin
          kde5.kwrited
          kde5.libkscreen
          kde5.libksysguard
          kde5.milou
          kde5.plasma-integration
          kde5.polkit-kde-agent
          kde5.systemsettings

          kde5.plasma-desktop
          kde5.plasma-workspace
          kde5.plasma-workspace-wallpapers

          kde5.dolphin-plugins
          kde5.ffmpegthumbs
          kde5.kdegraphics-thumbnailers
          kde5.kio-extras
          kde5.print-manager

          # Install Breeze icons if available
          (kde5.breeze-icons or kde5.oxygen-icons5 or kde5.oxygen-icons)
          pkgs.hicolor_icon_theme

          kde5.kde-gtk-config kde5.breeze-gtk

          pkgs.qt5.phonon-backend-gstreamer
        ]

        # Plasma 5.5 and later has a Breeze GTK theme.
        # If it is not available, Orion is very similar to Breeze.
        ++ lib.optional (!(lib.hasAttr "breeze-gtk" kde5)) pkgs.orion

        # Install activity manager if available
        ++ lib.optional (lib.hasAttr "kactivitymanagerd" kde5) kde5.kactivitymanagerd

        # frameworkintegration was split with plasma-integration in Plasma 5.6
        ++ lib.optional (lib.hasAttr "plasma-integration" kde5) kde5.plasma-integration

        ++ lib.optionals cfg.enableQt4Support [ kde5.breeze-qt4 pkgs.phonon-backend-gstreamer ]

        # Optional hardware support features
        ++ lib.optional config.hardware.bluetooth.enable kde5.bluedevil
        ++ lib.optional config.networking.networkmanager.enable kde5.plasma-nm
        ++ lib.optional config.hardware.pulseaudio.enable kde5.plasma-pa
        ++ lib.optional config.powerManagement.enable kde5.powerdevil
        ++ lib.optional config.services.colord.enable pkgs.colord-kde
        ++ lib.optionals config.services.samba.enable [ kde5.kdenetwork-filesharing pkgs.samba ];

      services.xserver.desktopManager.kde5.extraPackages =
        [
          kde5.khelpcenter
          kde5.oxygen

          kde5.dolphin
          kde5.konsole
        ];

      environment.pathsToLink = [ "/share" ];

      environment.etc = singleton {
        source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
        target = "X11/xkb";
      };

      environment.variables =
        {
          # Enable GTK applications to load SVG icons
          GST_PLUGIN_SYSTEM_PATH_1_0 =
            lib.makeSearchPath "/lib/gstreamer-1.0"
            (builtins.map (pkg: pkg.out) (with pkgs.gst_all_1; [
              gstreamer
              gst-plugins-base
              gst-plugins-good
              gst-plugins-ugly
              gst-plugins-bad
              gst-libav # for mp3 playback
            ]));
        }
        // (if (lib.hasAttr "breeze-icons" kde5)
            then { GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"; }
            else { });

      fonts.fonts = [
        (kde5.oxygen-fonts or pkgs.noto-fonts)
        pkgs.hack-font
      ];

      programs.ssh.askPassword = "${kde5.ksshaskpass.out}/bin/ksshaskpass";

      # Enable helpful DBus services.
      services.udisks2.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.dbus.packages =
        mkIf config.services.printing.enable [ pkgs.system-config-printer ];

      # Extra UDEV rules used by Solid
      services.udev.packages = [
        pkgs.libmtp
        pkgs.media-player-info
      ];

      services.xserver.displayManager.sddm = {
        theme = "breeze";
        themes = [
          kde5.ecm # for the setup-hook
          kde5.plasma-workspace
          kde5.breeze-icons
        ];
      };

      security.pam.services.kde = { allowNullPassword = true; };

      # Doing these one by one seems silly, but we currently lack a better
      # construct for handling common pam configs.
      security.pam.services.gdm.enableKwallet = true;
      security.pam.services.kdm.enableKwallet = true;
      security.pam.services.lightdm.enableKwallet = true;
      security.pam.services.sddm.enableKwallet = true;
      security.pam.services.slim.enableKwallet = true;

      # use kimpanel as the default IBus panel
      i18n.inputMethod.ibus.panel =
        lib.mkDefault
        "${pkgs.kde5.plasma-desktop}/lib/libexec/kimpanel-ibus-panel";

    })
  ];

}
