{ config, lib, pkgs, utils, ... }:

let
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.plasma5;

  # Use only for **internal** options.
  # This is not exactly user-friendly.
  kdeConfigurationType = with types;
    let
      valueTypes = (oneOf [
        bool
        float
        int
        str
      ]) // {
        description = "KDE Configuration value";
        emptyValue.value = "";
      };
      set = (nullOr (lazyAttrsOf valueTypes)) // {
        description = "KDE Configuration set";
        emptyValue.value = {};
      };
    in (lazyAttrsOf set) // {
        description = "KDE Configuration file";
        emptyValue.value = {};
      };

  inherit (lib)
    getBin optionalAttrs literalExpression
    mkRemovedOptionModule mkRenamedOptionModule
    mkDefault mkIf mkMerge mkOption mkPackageOption types;

  activationScript = ''
    ${set_XDG_CONFIG_HOME}

    # The KDE icon cache is supposed to update itself automatically, but it uses
    # the timestamp on the icon theme directory as a trigger. This doesn't work
    # on NixOS because the timestamp never changes. As a workaround, delete the
    # icon cache at login and session activation.
    # See also: http://lists-archives.org/kde-devel/26175-what-when-will-icon-cache-refresh.html
    rm -fv $HOME/.cache/icon-cache.kcache

    # xdg-desktop-settings generates this empty file but
    # it makes kbuildsyscoca5 fail silently. To fix this
    # remove that menu if it exists.
    rm -fv ''${XDG_CONFIG_HOME}/menus/applications-merged/xdg-desktop-menu-dummy.menu

    # Qt writes a weird ‘libraryPath’ line to
    # ~/.config/Trolltech.conf that causes the KDE plugin
    # paths of previous KDE invocations to be searched.
    # Obviously using mismatching KDE libraries is potentially
    # disastrous, so here we nuke references to the Nix store
    # in Trolltech.conf.  A better solution would be to stop
    # Qt from doing this wackiness in the first place.
    trolltech_conf="''${XDG_CONFIG_HOME}/Trolltech.conf"
    if [ -e "$trolltech_conf" ]; then
      ${getBin pkgs.gnused}/bin/sed -i "$trolltech_conf" -e '/nix\\store\|nix\/store/ d'
    fi

    # Remove the kbuildsyscoca5 cache. It will be regenerated
    # immediately after. This is necessary for kbuildsyscoca5 to
    # recognize that software that has been removed.
    rm -fv $HOME/.cache/ksycoca*

    ${pkgs.plasma5Packages.kservice}/bin/kbuildsycoca5
  '';

  set_XDG_CONFIG_HOME = ''
    # Set the default XDG_CONFIG_HOME if it is unset.
    # Per the XDG Base Directory Specification:
    # https://specifications.freedesktop.org/basedir-spec/latest
    # 1. Never export this variable! If it is unset, then child processes are
    # expected to set the default themselves.
    # 2. Contaminate / if $HOME is unset; do not check if $HOME is set.
    XDG_CONFIG_HOME=''${XDG_CONFIG_HOME:-$HOME/.config}
  '';

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
        default = "vlc";
        example = "gstreamer";
        description = "Phonon audio backend to install.";
      };

      useQtScaling = mkOption {
        type = types.bool;
        default = false;
        description = "Enable HiDPI scaling in Qt.";
      };

      runUsingSystemd = mkOption {
        description = "Use systemd to manage the Plasma session";
        type = types.bool;
        default = true;
      };

      notoPackage = mkPackageOption pkgs "Noto fonts" {
        default = [ "noto-fonts" ];
        example = "noto-fonts-lgc-plus";
      };

      # Internally allows configuring kdeglobals globally
      kdeglobals = mkOption {
        internal = true;
        default = {};
        type = kdeConfigurationType;
      };

      # Internally allows configuring kwin globally
      kwinrc = mkOption {
        internal = true;
        default = {};
        type = kdeConfigurationType;
      };

      mobile.enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable support for running the Plasma Mobile shell.
        '';
      };

      mobile.installRecommendedSoftware = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Installs software recommended for use with Plasma Mobile, but which
          is not strictly required for Plasma Mobile to run.
        '';
      };

      bigscreen.enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable support for running the Plasma Bigscreen session.
        '';
      };
    };
    environment.plasma5.excludePackages = mkOption {
        description = "List of default packages to exclude from the configuration";
        type = types.listOf types.package;
        default = [];
        example = literalExpression "[ pkgs.plasma5Packages.oxygen ]";
      };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "xserver" "desktopManager" "plasma5" "enableQt4Support" ] "Phonon no longer supports Qt 4.")
    (mkRemovedOptionModule [ "services" "xserver" "desktopManager" "plasma5" "supportDDC" ] "DDC/CI is no longer supported upstream.")
    (mkRenamedOptionModule [ "services" "xserver" "desktopManager" "kde5" ] [ "services" "xserver" "desktopManager" "plasma5" ])
    (mkRenamedOptionModule [ "services" "xserver" "desktopManager" "plasma5" "excludePackages" ] [ "environment" "plasma5" "excludePackages" ])
  ];

  config = mkMerge [
    # Common Plasma dependencies
    (mkIf (cfg.enable || cfg.mobile.enable || cfg.bigscreen.enable) {

      security.wrappers = {
        kwin_wayland = {
          owner = "root";
          group = "root";
          capabilities = "cap_sys_nice+ep";
          source = "${getBin pkgs.plasma5Packages.kwin}/bin/kwin_wayland";
        };
      } // optionalAttrs (!cfg.runUsingSystemd) {
        start_kdeinit = {
          setuid = true;
          owner = "root";
          group = "root";
          source = "${getBin pkgs.plasma5Packages.kinit}/libexec/kf5/start_kdeinit";
        };
      };

      qt.enable = true;

      environment.systemPackages =
        with pkgs.plasma5Packages;
        let
          requiredPackages = [
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
            kirigami2 # In system profile for SDDM theme. TODO: wrapper.
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
            kwayland-integration
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
            kscreen
            kscreenlocker
            kwayland
            kwin
            kwrited
            libkscreen
            libksysguard
            milou
            plasma-integration
            polkit-kde-agent

            qqc2-breeze-style
            qqc2-desktop-style

            plasma-desktop
            plasma-workspace
            plasma-workspace-wallpapers

            oxygen-sounds

            breeze-icons
            pkgs.hicolor-icon-theme

            kde-gtk-config
            breeze-gtk

            qtvirtualkeyboard

            pkgs.xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
          ];
          optionalPackages = [
            pkgs.aha # needed by kinfocenter for fwupd support
            plasma-browser-integration
            konsole
            oxygen
            (lib.getBin qttools) # Expose qdbus in PATH
          ];
        in
        requiredPackages
        ++ utils.removePackagesByName optionalPackages config.environment.plasma5.excludePackages

        # Phonon audio backend
        ++ lib.optional (cfg.phononBackend == "gstreamer") pkgs.plasma5Packages.phonon-backend-gstreamer
        ++ lib.optional (cfg.phononBackend == "vlc") pkgs.plasma5Packages.phonon-backend-vlc

        # Optional hardware support features
        ++ lib.optionals config.hardware.bluetooth.enable [ bluedevil bluez-qt pkgs.openobex pkgs.obexftp ]
        ++ lib.optional config.networking.networkmanager.enable plasma-nm
        ++ lib.optional config.hardware.pulseaudio.enable plasma-pa
        ++ lib.optional config.services.pipewire.pulse.enable plasma-pa
        ++ lib.optional config.powerManagement.enable powerdevil
        ++ lib.optional config.services.colord.enable pkgs.colord-kde
        ++ lib.optional config.services.hardware.bolt.enable pkgs.plasma5Packages.plasma-thunderbolt
        ++ lib.optional config.services.samba.enable kdenetwork-filesharing
        ++ lib.optional config.services.xserver.wacom.enable pkgs.wacomtablet
        ++ lib.optional config.services.flatpak.enable flatpak-kcm;

      # Extra services for D-Bus activation
      services.dbus.packages = [
        pkgs.plasma5Packages.kactivitymanagerd
      ];

      environment.pathsToLink = [
        # FIXME: modules should link subdirs of `/share` rather than relying on this
        "/share"
      ];

      environment.etc."X11/xkb".source = xcfg.xkb.dir;

      environment.sessionVariables = {
        PLASMA_USE_QT_SCALING = mkIf cfg.useQtScaling "1";

        # Needed for things that depend on other store.kde.org packages to install correctly,
        # notably Plasma look-and-feel packages (a.k.a. Global Themes)
        #
        # FIXME: this is annoyingly impure and should really be fixed at source level somehow,
        # but kpackage is a library so we can't just wrap the one thing invoking it and be done.
        # This also means things won't work for people not on Plasma, but at least this way it
        # works for SOME people.
        KPACKAGE_DEP_RESOLVERS_PATH = "${pkgs.plasma5Packages.frameworkintegration.out}/libexec/kf5/kpackagehandlers";
      };

      # Enable GTK applications to load SVG icons
      programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

      fonts.packages = with pkgs; [ cfg.notoPackage hack-font ];
      fonts.fontconfig.defaultFonts = {
        monospace = [ "Hack" "Noto Sans Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };

      programs.gnupg.agent.pinentryPackage = mkDefault pkgs.pinentry-qt;
      programs.ssh.askPassword = mkDefault "${pkgs.plasma5Packages.ksshaskpass.out}/bin/ksshaskpass";

      # Enable helpful DBus services.
      services.accounts-daemon.enable = true;
      programs.dconf.enable = true;
      # when changing an account picture the accounts-daemon reads a temporary file containing the image which systemsettings5 may place under /tmp
      systemd.services.accounts-daemon.serviceConfig.PrivateTmp = false;
      services.power-profiles-daemon.enable = mkDefault true;
      services.system-config-printer.enable = mkIf config.services.printing.enable (mkDefault true);
      services.udisks2.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.libinput.enable = mkDefault true;

      # Extra UDEV rules used by Solid
      services.udev.packages = [
        # libmtp has "bin", "dev", "out" outputs. UDEV rules file is in "out".
        pkgs.libmtp.out
        pkgs.media-player-info
      ];

      services.displayManager.sddm = {
        theme = mkDefault "breeze";
      };

      security.pam.services.kde = { allowNullPassword = true; };

      security.pam.services.login.kwallet.enable = true;

      systemd.user.services = {
        plasma-early-setup = mkIf cfg.runUsingSystemd {
          description = "Early Plasma setup";
          wantedBy = [ "graphical-session-pre.target" ];
          serviceConfig.Type = "oneshot";
          script = activationScript;
        };
      };

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [ pkgs.plasma5Packages.xdg-desktop-portal-kde ];
      xdg.portal.configPackages = mkDefault [ pkgs.plasma5Packages.xdg-desktop-portal-kde ];
      # xdg-desktop-portal-kde expects PipeWire to be running.
      # This does not, by default, replace PulseAudio.
      services.pipewire.enable = mkDefault true;

      # Update the start menu for each user that is currently logged in
      system.userActivationScripts.plasmaSetup = activationScript;

      programs.firefox.nativeMessagingHosts.packages = [ pkgs.plasma5Packages.plasma-browser-integration ];
      programs.chromium.enablePlasmaBrowserIntegration = true;
    })

    (mkIf (cfg.kwinrc != {}) {
      environment.etc."xdg/kwinrc".text = lib.generators.toINI {} cfg.kwinrc;
    })

    (mkIf (cfg.kdeglobals != {}) {
      environment.etc."xdg/kdeglobals".text = lib.generators.toINI {} cfg.kdeglobals;
    })

    # Plasma Desktop
    (mkIf cfg.enable {

      # Seed our configuration into nixos-generate-config
      system.nixos-generate-config.desktopConfiguration = [
        ''
          # Enable the Plasma 5 Desktop Environment.
          services.displayManager.sddm.enable = true;
          services.xserver.desktopManager.plasma5.enable = true;
        ''
      ];

      services.displayManager.sessionPackages = [ pkgs.plasma5Packages.plasma-workspace ];
      # Default to be `plasma` (X11) instead of `plasmawayland`, since plasma wayland currently has
      # many tiny bugs.
      # See: https://github.com/NixOS/nixpkgs/issues/143272
      services.displayManager.defaultSession = mkDefault "plasma";

      environment.systemPackages =
        with pkgs.plasma5Packages;
        let
          requiredPackages = [
            ksystemstats
            kinfocenter
            kmenuedit
            plasma-systemmonitor
            spectacle
            systemsettings

            dolphin
            dolphin-plugins
            ffmpegthumbs
            kdegraphics-thumbnailers
            kde-inotify-survey
            kio-admin
            kio-extras
          ];
          optionalPackages = [
            ark
            elisa
            gwenview
            okular
            khelpcenter
            print-manager
          ];
      in requiredPackages ++ utils.removePackagesByName optionalPackages config.environment.plasma5.excludePackages;

      systemd.user.services = {
        plasma-run-with-systemd = {
          description = "Run KDE Plasma via systemd";
          wantedBy = [ "basic.target" ];
          serviceConfig.Type = "oneshot";
          script = ''
            ${set_XDG_CONFIG_HOME}

            ${pkgs.plasma5Packages.kconfig}/bin/kwriteconfig5 \
              --file startkderc --group General --key systemdBoot ${lib.boolToString cfg.runUsingSystemd}
          '';
        };
      };
    })

    # Plasma Mobile
    (mkIf cfg.mobile.enable {
      assertions = [
        {
          # The user interface breaks without NetworkManager
          assertion = config.networking.networkmanager.enable;
          message = "Plasma Mobile requires NetworkManager.";
        }
        {
          # The user interface breaks without bluetooth
          assertion = config.hardware.bluetooth.enable;
          message = "Plasma Mobile requires Bluetooth.";
        }
        {
          # The user interface breaks without pulse
          assertion = config.hardware.pulseaudio.enable || (config.services.pipewire.enable && config.services.pipewire.pulse.enable);
          message = "Plasma Mobile requires pulseaudio.";
        }
      ];

      environment.systemPackages =
        with pkgs.plasma5Packages;
        [
          # Basic packages without which Plasma Mobile fails to work properly.
          plasma-mobile
          plasma-nano
          pkgs.maliit-framework
          pkgs.maliit-keyboard
        ]
        ++ lib.optionals (cfg.mobile.installRecommendedSoftware) (with pkgs.plasma5Packages.plasmaMobileGear; [
          # Additional software made for Plasma Mobile.
          alligator
          angelfish
          audiotube
          calindori
          kalk
          kasts
          kclock
          keysmith
          koko
          krecorder
          ktrip
          kweather
          plasma-dialer
          plasma-phonebook
          plasma-settings
          spacebar
        ])
      ;

      # The following services are needed or the UI is broken.
      hardware.bluetooth.enable = true;
      hardware.pulseaudio.enable = true;
      networking.networkmanager.enable = true;
      # Required for autorotate
      hardware.sensor.iio.enable = lib.mkDefault true;

      # Recommendations can be found here:
      #  - https://invent.kde.org/plasma-mobile/plasma-phone-settings/-/tree/master/etc/xdg
      # This configuration is the minimum required for Plasma Mobile to *work*.
      services.xserver.desktopManager.plasma5 = {
        kdeglobals = {
          KDE = {
            # This forces a numeric PIN for the lockscreen, which is the
            # recommendation from upstream.
            LookAndFeelPackage = lib.mkDefault "org.kde.plasma.phone";
          };
        };
        kwinrc = {
          "Wayland" = {
            "InputMethod[$e]" = "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
            "VirtualKeyboardEnabled" = "true";
          };
          "org.kde.kdecoration2" = {
            # No decorations (title bar)
            NoPlugin = lib.mkDefault "true";
          };
        };
      };

      services.displayManager.sessionPackages = [ pkgs.plasma5Packages.plasma-mobile ];
    })

    # Plasma Bigscreen
    (mkIf cfg.bigscreen.enable {
      environment.systemPackages =
        with pkgs.plasma5Packages;
        [
          plasma-nano
          plasma-settings
          plasma-bigscreen
          plasma-remotecontrollers

          aura-browser
          plank-player

          plasma-pa
          plasma-nm
          kdeconnect-kde
        ];

      services.displayManager.sessionPackages = [ pkgs.plasma5Packages.plasma-bigscreen ];

      # required for plasma-remotecontrollers to work correctly
      hardware.uinput.enable = true;
    })
  ];
}
