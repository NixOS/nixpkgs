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
    literalExpression
    mkDefault
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  activationScript = ''
    # will be rebuilt automatically
    rm -fv "$HOME/.cache/ksycoca"*
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

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> !config.services.xserver.desktopManager.plasma5.enable;
        message = "Cannot enable plasma5 and plasma6 at the same time!";
      }
    ];

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
          kio-admin # managing files as admin
          kio-extras # stuff for MTP, AFC, etc
          kio-fuse # fuse interface for KIO
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
          plasma-workspace-wallpapers
          pkgs.hicolor-icon-theme # fallback icons
          qqc2-breeze-style
          qqc2-desktop-style

          # misc Plasma extras
          kdeplasma-addons
          pkgs.xdg-user-dirs # recommended upstream

          # Plasma utilities
          kmenuedit
          kinfocenter
          plasma-systemmonitor
          ksystemstats
          libksysguard
          systemsettings
          kcmutils
        ];
        optionalPackages =
          [
            plasma-browser-integration
            konsole
            (lib.getBin qttools) # Expose qdbus in PATH
            ark
            elisa
            gwenview
            okular
            kate
            khelpcenter
            dolphin
            baloo-widgets # baloo information in Dolphin
            dolphin-plugins
            spectacle
            ffmpegthumbs
            krdp
            xwaylandvideobridge # exposes Wayland windows to X11 screen capture
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
        pkgs.plasma5Packages.kwayland-integration
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
      ++ lib.optional config.hardware.pulseaudio.enable plasma-pa
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
      sessionPackages = [ kdePackages.plasma-workspace ];
      defaultSession = mkDefault "plasma";
    };
    services.displayManager.sddm = {
      package = kdePackages.sddm;
      theme = mkDefault "breeze";
      wayland.compositor = "kwin";
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
      };
      kde-fingerprint = lib.mkIf config.services.fprintd.enable { fprintAuth = true; };
      kde-smartcard = lib.mkIf config.security.pam.p11.enable { p11Auth = true; };
    };

    security.wrappers = {
      kwin_wayland = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_nice+ep";
        source = "${lib.getBin pkgs.kdePackages.kwin}/bin/kwin_wayland";
      };
    };

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
