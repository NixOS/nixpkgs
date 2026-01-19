{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.desktopManager.plasma6;

  # Use only for **internal** options.
  # This is not exactly user-friendly.
  kdeConfigurationType =
    with types;
    let
      valueTypes =
        (oneOf [
          bool
          float
          int
          str
        ])
        // {
          description = "KDE Configuration value";
          emptyValue.value = "";
        };
      set = (nullOr (lazyAttrsOf valueTypes)) // {
        description = "KDE Configuration set";
        emptyValue.value = { };
      };
    in
    (lazyAttrsOf set)
    // {
      description = "KDE Configuration file";
      emptyValue.value = { };
    };

  inherit (pkgs) kdePackages;
  inherit (lib)
    literalExpression
    mkDefault
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    types
    ;

  activationScript = ''
    # will be rebuilt automatically
    rm -fv "''${XDG_CACHE_HOME:-$HOME/.cache}/ksycoca"*
  '';
in
{
  options = {
    services.desktopManager.plasma6 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Plasma 6 (KDE 6) desktop environment.";
      };

      enableQt5Integration = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Qt 5 integration (theming, etc). Disable for a pure Qt 6 system.";
      };

      notoPackage = mkPackageOption pkgs "Noto fonts - used for UI by default" {
        default = [ "noto-fonts" ];
        example = "noto-fonts-lgc-plus";
      };

      # Internally allows configuring kdeglobals globally
      kdeglobals = mkOption {
        internal = true;
        default = { };
        type = kdeConfigurationType;
      };

      # Internally allows configuring kwin globally
      kwinrc = mkOption {
        internal = true;
        default = { };
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
    };

    environment.plasma6.excludePackages = mkOption {
      description = "List of default packages to exclude from the configuration";
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ pkgs.kdePackages.elisa ]";
    };
  };

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "plasma6" "enable" ]
      [ "services" "desktopManager" "plasma6" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "plasma6" "enableQt5Integration" ]
      [ "services" "desktopManager" "plasma6" "enableQt5Integration" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "plasma6" "notoPackage" ]
      [ "services" "desktopManager" "plasma6" "notoPackage" ]
    )
  ];

  config = mkMerge [
    (mkIf (cfg.enable || cfg.mobile.enable) {
      qt.enable = true;
      programs.xwayland.enable = true;
      environment.systemPackages =
        with kdePackages;
        let
          requiredPackages = [
            qtwayland # Hack? To make everything run on Wayland
            qtsvg # Needed to render SVG icons

            # Frameworks with globally loadable bits
            frameworkintegration # provides Qt plugin
            kauth # provides helper service
            kcoreaddons # provides extra mime type info
            kded # provides helper service
            kfilemetadata # provides Qt plugins
            kguiaddons # provides geo URL handlers
            kiconthemes # provides Qt plugins
            kimageformats # provides Qt plugins
            qtimageformats # provides optional image formats such as .webp and .avif
            kio # provides helper service + a bunch of other stuff
            knighttime # night mode switching daemon
            kpackage # provides kpackagetool tool
            kservice # provides kbuildsycoca6 tool
            kunifiedpush # provides a background service and a KCM
            kwallet # provides helper service
            kwallet-pam # provides helper service
            kwalletmanager # provides KCMs and stuff
            plasma-activities # provides plasma-activities-cli tool
            solid # provides solid-hardware6 tool
            phonon-vlc # provides Phonon plugin

            # Core Plasma parts
            kwin
            kscreen
            libkscreen
            kscreenlocker
            kactivitymanagerd
            kde-cli-tools
            kglobalacceld # keyboard shortcut daemon
            kwrited # wall message proxy, not to be confused with kwrite
            baloo # system indexer
            milou # search engine atop baloo
            polkit-kde-agent-1 # polkit auth ui
            plasma-desktop
            plasma-workspace
            drkonqi # crash handler

            # Application integration
            libplasma # provides Kirigami platform theme
            plasma-integration # provides Qt platform theme
            kde-gtk-config # syncs KDE settings to GTK

            # Artwork + themes
            breeze
            breeze-icons
            breeze-gtk
            ocean-sound-theme
            pkgs.hicolor-icon-theme # fallback icons
            qqc2-breeze-style
            qqc2-desktop-style

            # misc Plasma extras
            kdeplasma-addons
            pkgs.xdg-user-dirs # recommended upstream

            # Plasma utilities
            kcmutils
          ];
          optionalPackages = [
            aurorae
            plasma-browser-integration
            plasma-workspace-wallpapers
            kwin-x11
            (lib.getBin qttools) # Expose qdbus in PATH
          ]
          ++ lib.optionals config.hardware.sensor.iio.enable [
            # This is required for autorotation in Plasma 6
            qtsensors
          ]
          ++ lib.optionals config.services.flatpak.enable [
            # Since PackageKit Nix support is not there yet,
            # only install discover if flatpak is enabled.
            discover
          ];
        in
        requiredPackages
        ++ utils.removePackagesByName optionalPackages config.environment.plasma6.excludePackages
        ++ lib.optionals config.services.desktopManager.plasma6.enableQt5Integration [
          breeze.qt5
          plasma-integration.qt5
          kwayland-integration
          (
            # Only symlink the KIO plugins, so we don't accidentally pull any services
            # like KCMs or kcookiejar
            let
              kioPluginPath = "${pkgs.plasma5Packages.qtbase.qtPluginPrefix}/kf5/kio";
              inherit (pkgs.plasma5Packages) kio;
            in
            pkgs.runCommand "kio5-plugins-only" { } ''
              mkdir -p $out/${kioPluginPath}
              ln -s ${kio}/${kioPluginPath}/* $out/${kioPluginPath}
            ''
          )
          kio-extras-kf5
        ]
        # Optional and hardware support features
        ++ lib.optionals config.hardware.bluetooth.enable [
          bluedevil
          bluez-qt
          pkgs.openobex
          pkgs.obexftp
        ]
        ++ lib.optional config.networking.networkmanager.enable plasma-nm
        ++ lib.optional config.services.pulseaudio.enable plasma-pa
        ++ lib.optional config.services.pipewire.pulse.enable plasma-pa
        ++ lib.optional config.powerManagement.enable powerdevil
        ++ lib.optional config.services.printing.enable print-manager
        ++ lib.optional config.services.colord.enable colord-kde
        ++ lib.optional config.services.hardware.bolt.enable plasma-thunderbolt
        ++ lib.optional config.services.samba.enable kdenetwork-filesharing
        ++ lib.optional config.services.xserver.wacom.enable wacomtablet
        ++ lib.optional config.services.flatpak.enable flatpak-kcm;

      environment.pathsToLink = [
        # FIXME: modules should link subdirs of `/share` rather than relying on this
        "/share"
        "/libexec" # for drkonqi
      ];

      environment.etc."X11/xkb".source = config.services.xserver.xkb.dir;

      # Add ~/.config/kdedefaults to XDG_CONFIG_DIRS for shells, since Plasma sets that.
      # FIXME: maybe we should append to XDG_CONFIG_DIRS in /etc/set-environment instead?
      environment.sessionVariables.XDG_CONFIG_DIRS = [ "$HOME/.config/kdedefaults" ];

      # Needed for things that depend on other store.kde.org packages to install correctly,
      # notably Plasma look-and-feel packages (a.k.a. Global Themes)
      #
      # FIXME: this is annoyingly impure and should really be fixed at source level somehow,
      # but kpackage is a library so we can't just wrap the one thing invoking it and be done.
      # This also means things won't work for people not on Plasma, but at least this way it
      # works for SOME people.
      environment.sessionVariables.KPACKAGE_DEP_RESOLVERS_PATH = "${kdePackages.frameworkintegration.out}/libexec/kf6/kpackagehandlers";

      # Enable GTK applications to load SVG icons
      programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

      fonts.packages = [
        cfg.notoPackage
        pkgs.hack-font
      ];
      fonts.fontconfig.defaultFonts = {
        monospace = [
          "Hack"
          "Noto Sans Mono"
        ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };

      programs.gnupg.agent.pinentryPackage = mkDefault pkgs.pinentry-qt;
      programs.kde-pim.enable = mkDefault true;
      programs.ssh.askPassword = mkDefault "${kdePackages.ksshaskpass.out}/bin/ksshaskpass";

      # Enable helpful DBus services.
      services.accounts-daemon.enable = true;
      # when changing an account picture the accounts-daemon reads a temporary file containing the image which systemsettings5 may place under /tmp
      systemd.services.accounts-daemon.serviceConfig.PrivateTmp = false;

      services.power-profiles-daemon.enable = mkDefault true;
      services.system-config-printer.enable = mkIf config.services.printing.enable (mkDefault true);
      services.udisks2.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.libinput.enable = mkDefault true;
      services.geoclue2.enable = mkDefault true;
      services.fwupd.enable = mkDefault true;

      # Extra UDEV rules used by Solid
      services.udev.packages = [
        # libmtp has "bin", "dev", "out" outputs. UDEV rules file is in "out".
        pkgs.libmtp.out
        pkgs.media-player-info
      ];

      # Set up Dr. Konqi as crash handler
      systemd.packages = [ kdePackages.drkonqi ];
      systemd.services."drkonqi-coredump-processor@".wantedBy = [ "systemd-coredump@.service" ];

      xdg.icons.enable = true;
      xdg.icons.fallbackCursorThemes = mkDefault [ "breeze_cursors" ];

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [
        kdePackages.kwallet
        kdePackages.xdg-desktop-portal-kde
        pkgs.xdg-desktop-portal-gtk
      ];
      xdg.portal.configPackages = mkDefault [ kdePackages.plasma-workspace ];
      services.pipewire.enable = mkDefault true;

      # Enable screen reader by default
      services.orca.enable = mkDefault true;

      services.displayManager.sddm = {
        package = kdePackages.sddm;
        theme = mkDefault "breeze";
        wayland = mkDefault {
          enable = true;
          compositor = "kwin";
        };
        extraPackages = with kdePackages; [
          breeze-icons
          kirigami
          libplasma
          plasma5support
          qtsvg
          qtvirtualkeyboard
        ];
      };

      security.pam.services = {
        login.kwallet = {
          enable = true;
          package = kdePackages.kwallet-pam;
        };
        kde = {
          allowNullPassword = true;
          kwallet = {
            enable = true;
            package = kdePackages.kwallet-pam;
          };
          # "kde" must not have fingerprint authentication otherwise it can block password login.
          # See https://github.com/NixOS/nixpkgs/issues/239770 and https://invent.kde.org/plasma/kscreenlocker/-/merge_requests/163.
          fprintAuth = false;
          p11Auth = false;
        };
        kde-fingerprint = lib.mkIf config.services.fprintd.enable {
          fprintAuth = true;
          p11Auth = false;
        };
        kde-smartcard = lib.mkIf config.security.pam.p11.enable {
          p11Auth = true;
          fprintAuth = false;
        };
      };

      security.wrappers.kwin_wayland = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_nice+ep";
        source = "${lib.getBin pkgs.kdePackages.kwin}/bin/kwin_wayland";
      };

      # Upstream recommends allowing set-timezone and set-ntp so that the KCM and
      # the automatic timezone logic work without user interruption.
      # However, on NixOS NTP cannot be overwritten via dbus, and timezone
      # can only be set if `time.timeZone` is set to `null`. So, we only allow
      # set-timezone, and we only allow it when the timezone can actually be set.
      security.polkit.extraConfig = lib.mkIf (config.time.timeZone != null) ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.timedate1.set-timezone" && subject.active) {
            return polkit.Result.YES;
          }
        });
      '';

      programs.dconf.enable = true;

      programs.firefox.nativeMessagingHosts.packages = [ kdePackages.plasma-browser-integration ];

      programs.chromium = {
        enablePlasmaBrowserIntegration = true;
        plasmaBrowserIntegrationPackage = pkgs.kdePackages.plasma-browser-integration;
      };

      programs.kdeconnect.package = kdePackages.kdeconnect-kde;
      programs.partition-manager.package = kdePackages.partitionmanager;

      # FIXME: ugly hack. See #292632 for details.
      system.userActivationScripts.rebuildSycoca = activationScript;
      systemd.user.services.nixos-rebuild-sycoca = {
        description = "Rebuild KDE system configuration cache";
        wantedBy = [ "graphical-session-pre.target" ];
        serviceConfig.Type = "oneshot";
        script = activationScript;
      };
    })

    (mkIf (cfg.kwinrc != { }) {
      environment.etc."xdg/kwinrc".text = lib.generators.toINI { } cfg.kwinrc;
    })

    (mkIf (cfg.kdeglobals != { }) {
      environment.etc."xdg/kdeglobals".text = lib.generators.toINI { } cfg.kdeglobals;
    })

    # Plasma Desktop
    (mkIf cfg.enable {
      services.displayManager = {
        sessionPackages = [ kdePackages.plasma-workspace ];
        defaultSession = mkDefault "plasma";
      };

      environment.systemPackages =
        with kdePackages;
        let
          requiredPackages = [
            # Plasma utilities
            kmenuedit
            kinfocenter
            plasma-systemmonitor
            ksystemstats
            libksysguard
            systemsettings

            kdegraphics-thumbnailers # pdf etc thumbnailer
            kde-inotify-survey # warns the user on low inotifywatch limits
            kio-admin # managing files as admin
            kio-extras # stuff for MTP, AFC, etc
            kio-fuse # fuse interface for KIO
          ];
          optionalPackages = [
            konsole
            ark
            elisa
            kate
            ktexteditor # provides elevated actions for kate
            gwenview
            okular
            khelpcenter
            dolphin
            baloo-widgets # baloo information in Dolphin
            dolphin-plugins
            spectacle
            ffmpegthumbs
            krdp
            kconfig # required for xdg-terminal from xdg-utils
          ];
        in
        requiredPackages
        ++ utils.removePackagesByName optionalPackages config.environment.plasma6.excludePackages;

      security.wrappers = {
        ksystemstats_intel_helper = {
          owner = "root";
          group = "root";
          capabilities = "cap_perfmon+ep";
          source = "${pkgs.kdePackages.ksystemstats}/libexec/ksystemstats_intel_helper";
        };

        ksgrd_network_helper = {
          owner = "root";
          group = "root";
          capabilities = "cap_net_raw+ep";
          source = "${pkgs.kdePackages.libksysguard}/libexec/ksysguard/ksgrd_network_helper";
        };
      };
    })

    # Plasma Mobile
    (mkIf cfg.mobile.enable {
      assertions = [
        {
          # The user interface breaks without pulse
          assertion =
            config.services.pulseaudio.enable
            || (config.services.pipewire.enable && config.services.pipewire.pulse.enable);
          message = "Plasma Mobile requires a Pulseaudio compatible sound server.";
        }
      ];

      environment.systemPackages =
        with pkgs.kdePackages;
        [
          # Basic packages without which Plasma Mobile fails to work properly.
          plasma-mobile
          plasma-nano
          pkgs.maliit-framework
          pkgs.maliit-keyboard
        ]
        ++ lib.optionals (cfg.mobile.installRecommendedSoftware) (
          with pkgs.kdePackages;
          [
            # Additional software made for Plasma Mobile.
            alligator
            # TODO: doesn't build
            # angelfish
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
            qmlkonsole
            spacebar
          ]
        );

      # The following services are needed or the UI is broken.
      hardware.bluetooth.enable = true;
      networking.networkmanager.enable = true;
      # Required for autorotate
      hardware.sensor.iio.enable = lib.mkDefault true;

      # Recommendations can be found here:
      #  - https://invent.kde.org/plasma-mobile/plasma-phone-settings/-/tree/master/etc/xdg
      # This configuration is the minimum required for Plasma Mobile to *work*.
      services.desktopManager.plasma6 = {
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

      services.displayManager.sessionPackages = [ pkgs.kdePackages.plasma-mobile ];
    })
  ];
}
