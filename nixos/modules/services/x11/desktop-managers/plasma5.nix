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

      phononBackend = mkOption {
        type = types.enum [ "gstreamer" "vlc" ];
        default = "gstreamer";
        example = "vlc";
        description = "Phonon audio backend to install.";
      };
    };

  };

  imports = [
    (mkRemovedOptionModule [ "services" "xserver" "desktopManager" "plasma5" "enableQt4Support" ] "Phonon no longer supports Qt 4.")
    (mkRenamedOptionModule [ "services" "xserver" "desktopManager" "kde5" ] [ "services" "xserver" "desktopManager" "plasma5" ])
  ];

  config = mkMerge [
    (mkIf cfg.enable {
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
        kcheckpass.source = "${lib.getBin plasma5.kscreenlocker}/libexec/kcheckpass";
        start_kdeinit.source = "${lib.getBin pkgs.kinit}/libexec/kf5/start_kdeinit";
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

          xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
        ]

        # Phonon audio backend
        ++ lib.optional (cfg.phononBackend == "gstreamer") libsForQt5.phonon-backend-gstreamer
        ++ lib.optional (cfg.phononBackend == "vlc") libsForQt5.phonon-backend-vlc

        # Optional hardware support features
        ++ lib.optionals config.hardware.bluetooth.enable [ bluedevil bluez-qt openobex obexftp ]
        ++ lib.optional config.networking.networkmanager.enable plasma-nm
        ++ lib.optional config.hardware.pulseaudio.enable plasma-pa
        ++ lib.optional config.powerManagement.enable powerdevil
        ++ lib.optional config.services.colord.enable colord-kde
        ++ lib.optionals config.services.samba.enable [ kdenetwork-filesharing pkgs.samba ]
        ++ lib.optional config.services.xserver.wacom.enable wacomtablet;

      environment.pathsToLink = [
        # FIXME: modules should link subdirs of `/share` rather than relying on this
        "/share"
      ];

      environment.etc."X11/xkb".source = xcfg.xkbDir;

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
      services.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));
      services.xserver.libinput.enable = mkDefault true;

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

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];

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
