{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.desktopManager.plasma6;

  inherit (pkgs) kdePackages;
  inherit (lib)
    getBin
    literalExpression
    mkDefault
    mkIf
    mkOption
    mkPackageOption
    mkRenamedOptionModule
    optional
    optionals
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
    };

    environment.plasma6.excludePackages = mkOption {
      description = "List of default packages to exclude from the configuration";
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ pkgs.kdePackages.elisa ]";
    };
  };

  imports = [
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "plasma6" "enable" ]
      [ "services" "desktopManager" "plasma6" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "plasma6" "enableQt5Integration" ]
      [ "services" "desktopManager" "plasma6" "enableQt5Integration" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "plasma6" "notoPackage" ]
      [ "services" "desktopManager" "plasma6" "notoPackage" ]
    )
  ];

  config = mkIf cfg.enable {
    qt.enable = true;
    programs.xwayland.enable = true;
    environment.systemPackages =
      let
        requiredPackages =
          (builtins.attrValues {
            inherit (kdePackages)
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
              kio-admin # managing files as admin
              kio-extras # stuff for MTP, AFC, etc
              kio-fuse # fuse interface for KIO
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
              kdegraphics-thumbnailers # pdf etc thumbnailer
              polkit-kde-agent-1 # polkit auth ui
              plasma-desktop
              plasma-workspace
              drkonqi # crash handler
              kde-inotify-survey # warns the user on low inotifywatch limits

              # Application integration
              libplasma # provides Kirigami platform theme
              plasma-integration # provides Qt platform theme
              kde-gtk-config # syncs KDE settings to GTK

              # Artwork + themes
              breeze
              breeze-icons
              breeze-gtk
              ocean-sound-theme
              qqc2-breeze-style
              qqc2-desktop-style

              # misc Plasma extras
              kdeplasma-addons

              # Plasma utilities
              kmenuedit
              kinfocenter
              plasma-systemmonitor
              ksystemstats
              libksysguard
              systemsettings
              kcmutils
              ;
          })
          ++ [
            pkgs.hicolor-icon-theme # fallback icons
            pkgs.xdg-user-dirs # recommended upstream
          ];
        optionalPackages =
          (builtins.attrValues {
            inherit (kdePackages)
              aurorae
              plasma-browser-integration
              plasma-workspace-wallpapers
              konsole
              kwin-x11
              ark
              elisa
              gwenview
              okular
              kate
              ktexteditor # provides elevated actions for kate
              khelpcenter
              dolphin
              baloo-widgets # baloo information in Dolphin
              dolphin-plugins
              spectacle
              ffmpegthumbs
              krdp
              kconfig # required for xdg-terminal from xdg-utils
              qtbase # for qtpaths which is required for xdg-mime from xdg-utils
              # touch keyboard
              plasma-keyboard
              qtvirtualkeyboard # used by plasma-keyboard KCM

              # experimental(?) Union theme
              union
              ;
          })
          ++ [ (getBin kdePackages.qttools) ] # Expose qdbus in PATH
          ++ optional config.networking.networkmanager.enable kdePackages.qrca
          ++ optionals config.hardware.sensor.iio.enable [
            # This is required for autorotation in Plasma 6
            kdePackages.qtsensors
          ]
          ++ optionals (config.services.flatpak.enable || config.services.fwupd.enable) [
            # Since PackageKit Nix support is not there yet,
            # only install discover if flatpak or fwupd is enabled.
            kdePackages.discover
          ];
      in
      requiredPackages
      ++ utils.removePackagesByName optionalPackages config.environment.plasma6.excludePackages
      ++ optionals config.services.desktopManager.plasma6.enableQt5Integration [
        kdePackages.breeze.qt5
        kdePackages.plasma-integration.qt5
        kdePackages.kwayland-integration
        (
          # Only symlink the KIO plugins, so we don't accidentally pull any services
          # like KCMs or kcookiejar
          let
            kioPluginPath = "${pkgs.libsForQt5.qtbase.qtPluginPrefix}/kf5/kio";
            inherit (pkgs.libsForQt5.__internalKF5) kio;
          in
          pkgs.runCommand "kio5-plugins-only" { } ''
            mkdir -p $out/${kioPluginPath}
            ln -s ${kio}/${kioPluginPath}/* $out/${kioPluginPath}
          ''
        )
        kdePackages.kio-extras-kf5
      ]
      # Optional and hardware support features
      ++ optionals config.hardware.bluetooth.enable [
        kdePackages.bluedevil
        kdePackages.bluez-qt
        pkgs.openobex
        pkgs.obexftp
      ]
      ++ optional config.networking.networkmanager.enable kdePackages.plasma-nm
      ++ optional config.services.pulseaudio.enable kdePackages.plasma-pa
      ++ optional config.services.pipewire.pulse.enable kdePackages.plasma-pa
      ++ optional config.powerManagement.enable kdePackages.powerdevil
      ++ optional config.services.printing.enable kdePackages.print-manager
      ++ optional config.hardware.sane.enable kdePackages.skanpage
      ++ optional config.services.colord.enable kdePackages.colord-kde
      ++ optional config.services.hardware.bolt.enable kdePackages.plasma-thunderbolt
      ++ optional config.services.samba.enable kdePackages.kdenetwork-filesharing
      ++ optional config.services.xserver.wacom.enable kdePackages.wacomtablet
      ++ optional config.services.flatpak.enable kdePackages.flatpak-kcm;

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
    programs.fuse.enable = true;
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

    services.displayManager = {
      sessionPackages = [ kdePackages.plasma-workspace.sessions ];
      defaultSession = mkDefault "plasma";
    };
    services.displayManager.sddm = {
      package = kdePackages.sddm;
      theme = mkDefault "breeze";
      wayland = mkDefault {
        enable = true;
        compositor = "kwin";
      };
      extraPackages = builtins.attrValues {
        inherit (kdePackages)
          breeze-icons
          kirigami
          libplasma
          plasma5support
          qtsvg
          qtvirtualkeyboard
          ;
      };
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
      kde-fingerprint = mkIf config.services.fprintd.enable {
        fprintAuth = true;
        p11Auth = false;
      };
      kde-smartcard = mkIf config.security.pam.p11.enable {
        p11Auth = true;
        fprintAuth = false;
      };
    };

    security.wrappers = {
      kwin_wayland = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_nice+ep";
        source = "${getBin pkgs.kdePackages.kwin}/bin/kwin_wayland";
      };

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

    # Upstream recommends allowing set-timezone and set-ntp so that the KCM and
    # the automatic timezone logic work without user interruption.
    # However, on NixOS NTP cannot be overwritten via dbus, and timezone
    # can only be set if `time.timeZone` is set to `null`. So, we only allow
    # set-timezone, and we only allow it when the timezone can actually be set.
    security.polkit.extraConfig = mkIf (config.time.timeZone != null) ''
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
  };
}
