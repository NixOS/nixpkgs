{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.plasma5;

  inherit (pkgs) kdeApplications plasma5 libsForQt5 qt5;

in

{
  options = {

    services.xserver.desktopManager.plasma5 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Plasma 5 (KDE 5) desktop environment.";
      };

      enableQt4Support = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable support for Qt 4-based applications. Particularly, install a
          default backend for Phonon.
        '';
      };

    };

  };


  config = mkMerge [
    (mkIf (xcfg.enable && cfg.enable) {
      services.xserver.desktopManager.session = singleton {
        name = "plasma5";
        bgSupport = true;
        start = ''
          # Load PulseAudio module for routing support.
          # See http://colin.guthr.ie/2009/10/so-how-does-the-kde-pulseaudio-support-work-anyway/
          ${optionalString config.hardware.pulseaudio.enable ''
            ${getBin config.hardware.pulseaudio.package}/bin/pactl load-module module-device-manager "do_routing=1"
          ''}

          if [ -f "$HOME/.config/kdeglobals" ]
          then
              # Remove extraneous font style names.
              # See also: https://phabricator.kde.org/D9070
              ${getBin pkgs.gnused}/bin/sed -i "$HOME/.config/kdeglobals" \
                  -e '/^fixed=/ s/,Regular$//' \
                  -e '/^font=/ s/,Regular$//' \
                  -e '/^menuFont=/ s/,Regular$//' \
                  -e '/^smallestReadableFont=/ s/,Regular$//' \
                  -e '/^toolBarFont=/ s/,Regular$//'
          fi

          exec "${getBin plasma5.plasma-workspace}/bin/startkde"
        '';
      };

      security.wrappers = {
        kcheckpass.source = "${lib.getBin plasma5.kscreenlocker}/lib/libexec/kcheckpass";
        "start_kdeinit".source = "${lib.getBin pkgs.kinit}/lib/libexec/kf5/start_kdeinit";
        kwin_wayland = {
          source = "${lib.getBin plasma5.kwin}/bin/kwin_wayland";
          capabilities = "cap_sys_nice+ep";
        };
      };

      environment.systemPackages = with pkgs; with qt5; with libsForQt5; with plasma5; with kdeApplications;
        [
          frameworkintegration
          kactivities
          kauth
          kcmutils
          kconfig
          kconfigwidgets
          kcoreaddons
          kdoctools
          kdbusaddons
          kdeclarative
          kded
          kdesu
          kdnssd
          kemoticons
          kfilemetadata
          kglobalaccel
          kguiaddons
          kiconthemes
          kidletime
          kimageformats
          kinit
          kio
          kjobwidgets
          knewstuff
          knotifications
          knotifyconfig
          kpackage
          kparts
          kpeople
          krunner
          kservice
          ktextwidgets
          kwallet
          kwallet-pam
          kwalletmanager
          kwayland
          kwidgetsaddons
          kxmlgui
          kxmlrpcclient
          plasma-framework
          solid
          sonnet
          threadweaver

          breeze-qt5
          kactivitymanagerd
          kde-cli-tools
          kdecoration
          kdeplasma-addons
          kgamma5
          khotkeys
          kinfocenter
          kmenuedit
          kscreen
          kscreenlocker
          ksysguard
          kwayland
          kwin
          kwrited
          libkscreen
          libksysguard
          milou
          plasma-integration
          polkit-kde-agent
          systemsettings

          plasma-desktop
          plasma-workspace
          plasma-workspace-wallpapers

          dolphin
          dolphin-plugins
          ffmpegthumbs
          kdegraphics-thumbnailers
          khelpcenter
          kio-extras
          konsole
          oxygen
          print-manager

          breeze-icons
          pkgs.hicolor-icon-theme

          kde-gtk-config breeze-gtk

          qtvirtualkeyboard

          libsForQt56.phonon-backend-gstreamer
          libsForQt5.phonon-backend-gstreamer

          xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
        ]

        ++ lib.optionals cfg.enableQt4Support [ pkgs.phonon-backend-gstreamer ]

        # Optional hardware support features
        ++ lib.optional config.hardware.bluetooth.enable bluedevil
        ++ lib.optional config.networking.networkmanager.enable plasma-nm
        ++ lib.optional config.hardware.pulseaudio.enable plasma-pa
        ++ lib.optional config.powerManagement.enable powerdevil
        ++ lib.optional config.services.colord.enable colord-kde
        ++ lib.optionals config.services.samba.enable [ kdenetwork-filesharing pkgs.samba ];

      environment.pathsToLink = [
        # FIXME: modules should link subdirs of `/share` rather than relying on this
        "/share"
      ];

      environment.etc = singleton {
        source = xcfg.xkbDir;
        target = "X11/xkb";
      };

      # Enable GTK applications to load SVG icons
      services.xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

      fonts.fonts = with pkgs; [ noto-fonts hack-font ];
      fonts.fontconfig.defaultFonts = {
        monospace = [ "Hack" "Noto Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };

      programs.ssh.askPassword = mkDefault "${plasma5.ksshaskpass.out}/bin/ksshaskpass";

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
        theme = mkDefault "breeze";
      };

      security.pam.services.kde = { allowNullPassword = true; };

      # Doing these one by one seems silly, but we currently lack a better
      # construct for handling common pam configs.
      security.pam.services.gdm.enableKwallet = true;
      security.pam.services.kdm.enableKwallet = true;
      security.pam.services.lightdm.enableKwallet = true;
      security.pam.services.sddm.enableKwallet = true;
      security.pam.services.slim.enableKwallet = true;

      # Update the start menu for each user that is currently logged in
      system.userActivationScripts.plasmaSetup = ''
        # The KDE icon cache is supposed to update itself
        # automatically, but it uses the timestamp on the icon
        # theme directory as a trigger.  Since in Nix the
        # timestamp is always the same, this doesn't work.  So as
        # a workaround, nuke the icon cache on login.  This isn't
        # perfect, since it may require logging out after
        # installing new applications to update the cache.
        # See http://lists-archives.org/kde-devel/26175-what-when-will-icon-cache-refresh.html
        rm -fv $HOME/.cache/icon-cache.kcache

        # xdg-desktop-settings generates this empty file but
        # it makes kbuildsyscoca5 fail silently. To fix this
        # remove that menu if it exists.
        rm -fv $HOME/.config/menus/applications-merged/xdg-desktop-menu-dummy.menu

        # Remove the kbuildsyscoca5 cache. It will be regenerated
        # immediately after. This is necessary for kbuildsyscoca5 to
        # recognize that software that has been removed.
        rm -fv $HOME/.cache/ksycoca*

        ${pkgs.libsForQt5.kservice}/bin/kbuildsycoca5
      '';
    })
  ];

}
