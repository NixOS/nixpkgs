{
  config,
  lib,
  pkgs,
  utils,
  ...
}: let
  cfg = config.services.desktopManager.plasma6;

  inherit (pkgs) kdePackages;
  inherit (lib) literalExpression mkDefault mkIf mkOption mkPackageOptionMD types;

  activationScript = ''
    # will be rebuilt automatically
    rm -fv $HOME/.cache/ksycoca*
  '';
in {
  options = {
    services.desktopManager.plasma6 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Enable the Plasma 6 (KDE 6) desktop environment.";
      };

      enableQt5Integration = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Enable Qt 5 integration (theming, etc). Disable for a pure Qt 6 system.";
      };

      notoPackage = mkPackageOptionMD pkgs "Noto fonts - used for UI by default" {
        default = ["noto-fonts"];
        example = "noto-fonts-lgc-plus";
      };
    };

    environment.plasma6.excludePackages = mkOption {
      description = lib.mdDoc "List of default packages to exclude from the configuration";
      type = types.listOf types.package;
      default = [];
      example = literalExpression "[ pkgs.kdePackages.elisa ]";
    };
  };

  imports = [
    (lib.mkRenamedOptionModule [ "services" "xserver" "desktopManager" "plasma6" "enable" ] [ "services" "desktopManager" "plasma6" "enable" ])
    (lib.mkRenamedOptionModule [ "services" "xserver" "desktopManager" "plasma6" "enableQt5Integration" ] [ "services" "desktopManager" "plasma6" "enableQt5Integration" ])
    (lib.mkRenamedOptionModule [ "services" "xserver" "desktopManager" "plasma6" "notoPackage" ] [ "services" "desktopManager" "plasma6" "notoPackage" ])
  ];

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> !config.services.xserver.desktopManager.plasma5.enable;
        message = "Cannot enable plasma5 and plasma6 at the same time!";
      }
    ];

    qt.enable = true;
    environment.systemPackages = with kdePackages; let
      requiredPackages = [
        # Hack? To make everything run on Wayland
        qtwayland
        # Needed to render SVG icons
        qtsvg

        # Frameworks with globally loadable bits
        frameworkintegration # provides Qt plugin
        kauth # provides helper service
        kcoreaddons # provides extra mime type info
        kded # provides helper service
        kfilemetadata # provides Qt plugins
        kguiaddons # provides geo URL handlers
        kiconthemes # provides Qt plugins
        kimageformats # provides Qt plugins
        kio # provides helper service + a bunch of other stuff
        kpackage # provides kpackagetool tool
        kservice # provides kbuildsycoca6 tool
        kwallet # provides helper service
        kwallet-pam # provides helper service
        kwalletmanager # provides KCMs and stuff
        plasma-activities # provides plasma-activities-cli tool
        solid # provides solid-hardware6 tool
        phonon-vlc # provides Phonon plugin

        # Core Plasma parts
        kwin
        pkgs.xwayland

        kscreen
        libkscreen

        kscreenlocker

        kactivitymanagerd
        kde-cli-tools
        kglobalacceld
        kwrited # wall message proxy, not to be confused with kwrite

        milou
        polkit-kde-agent-1

        plasma-desktop
        plasma-workspace

        # Crash handler
        drkonqi

        # Application integration
        libplasma # provides Kirigami platform theme
        plasma-integration # provides Qt platform theme
        kde-gtk-config

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

        spectacle
        systemsettings
        kcmutils

        # Gear
        baloo
        dolphin
        dolphin-plugins
        ffmpegthumbs
        kdegraphics-thumbnailers
        kde-inotify-survey
        kio-admin
        kio-extras
        kio-fuse
      ];
      optionalPackages = [
        plasma-browser-integration
        konsole
        (lib.getBin qttools) # Expose qdbus in PATH

        ark
        elisa
        gwenview
        okular
        kate
        khelpcenter
        print-manager
      ];
    in
      requiredPackages
      ++ utils.removePackagesByName optionalPackages config.environment.plasma6.excludePackages
      ++ lib.optionals config.services.desktopManager.plasma6.enableQt5Integration [
        breeze.qt5
        plasma-integration.qt5
        pkgs.plasma5Packages.kwayland-integration
        pkgs.plasma5Packages.kio
        kio-extras-kf5
      ]
      # Optional hardware support features
      ++ lib.optionals config.hardware.bluetooth.enable [bluedevil bluez-qt pkgs.openobex pkgs.obexftp]
      ++ lib.optional config.networking.networkmanager.enable plasma-nm
      ++ lib.optional config.hardware.pulseaudio.enable plasma-pa
      ++ lib.optional config.services.pipewire.pulse.enable plasma-pa
      ++ lib.optional config.powerManagement.enable powerdevil
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
    environment.sessionVariables.XDG_CONFIG_DIRS = ["$HOME/.config/kdedefaults"];

    # Needed for things that depend on other store.kde.org packages to install correctly,
    # notably Plasma look-and-feel packages (a.k.a. Global Themes)
    #
    # FIXME: this is annoyingly impure and should really be fixed at source level somehow,
    # but kpackage is a library so we can't just wrap the one thing invoking it and be done.
    # This also means things won't work for people not on Plasma, but at least this way it
    # works for SOME people.
    environment.sessionVariables.KPACKAGE_DEP_RESOLVERS_PATH = "${kdePackages.frameworkintegration.out}/libexec/kf6/kpackagehandlers";

    # Enable GTK applications to load SVG icons
    services.xserver.gdk-pixbuf.modulePackages = [pkgs.librsvg];

    fonts.packages = [cfg.notoPackage pkgs.hack-font];
    fonts.fontconfig.defaultFonts = {
      monospace = ["Hack" "Noto Sans Mono"];
      sansSerif = ["Noto Sans"];
      serif = ["Noto Serif"];
    };

    programs.gnupg.agent.pinentryPackage = mkDefault pkgs.pinentry-qt;
    programs.ssh.askPassword = mkDefault "${kdePackages.ksshaskpass.out}/bin/ksshaskpass";

    # Enable helpful DBus services.
    services.accounts-daemon.enable = true;
    # when changing an account picture the accounts-daemon reads a temporary file containing the image which systemsettings5 may place under /tmp
    systemd.services.accounts-daemon.serviceConfig.PrivateTmp = false;

    services.power-profiles-daemon.enable = mkDefault true;
    services.system-config-printer.enable = mkIf config.services.printing.enable (mkDefault true);
    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;
    services.xserver.libinput.enable = mkDefault true;

    # Extra UDEV rules used by Solid
    services.udev.packages = [
      # libmtp has "bin", "dev", "out" outputs. UDEV rules file is in "out".
      pkgs.libmtp.out
      pkgs.media-player-info
    ];

    # Set up Dr. Konqi as crash handler
    systemd.packages = [kdePackages.drkonqi];
    systemd.services."drkonqi-coredump-processor@".wantedBy = ["systemd-coredump@.service"];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [kdePackages.xdg-desktop-portal-kde];
    xdg.portal.configPackages = mkDefault [kdePackages.xdg-desktop-portal-kde];
    services.pipewire.enable = mkDefault true;

    services.xserver.displayManager = {
      sessionPackages = [kdePackages.plasma-workspace];
      defaultSession = mkDefault "plasma";
    };
    services.xserver.displayManager.sddm = {
      package = kdePackages.sddm;
      theme = mkDefault "breeze";
      wayland.compositor = "kwin";
      extraPackages = with kdePackages; [
        breeze-icons
        kirigami
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
      kde.kwallet = {
        enable = true;
        package = kdePackages.kwallet-pam;
      };
      kde-fingerprint = lib.mkIf config.services.fprintd.enable { fprintAuth = true; };
      kde-smartcard = lib.mkIf config.security.pam.p11.enable { p11Auth = true; };
    };

    programs.dconf.enable = true;

    programs.firefox.nativeMessagingHosts.packages = [kdePackages.plasma-browser-integration];

    programs.chromium = {
      enablePlasmaBrowserIntegration = true;
      plasmaBrowserIntegrationPackage = pkgs.kdePackages.plasma-browser-integration;
    };

    programs.kdeconnect.package = kdePackages.kdeconnect-kde;

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
