{ config, lib, pkgs, ... }:

let
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.plasma5;

  libsForQt5 = pkgs.plasma5Packages;
  inherit (libsForQt5) kdeGear kdeFrameworks plasma5;
  inherit (pkgs) writeText;
  inherit (lib)
    getBin optionalString
    mkRemovedOptionModule mkRenamedOptionModule
    mkDefault mkIf mkMerge mkOption types;

  ini = pkgs.formats.ini { };

  pulseaudio = config.hardware.pulseaudio;
  pactl = "${getBin pulseaudio.package}/bin/pactl";
  sed = "${getBin pkgs.gnused}/bin/sed";

  gtkrc2 = writeText "gtkrc-2.0" ''
    # Default GTK+ 2 config for NixOS Plasma 5
    include "/run/current-system/sw/share/themes/Breeze/gtk-2.0/gtkrc"
    style "user-font"
    {
      font_name="Sans Serif Regular"
    }
    widget_class "*" style "user-font"
    gtk-font-name="Sans Serif Regular 10"
    gtk-theme-name="Breeze"
    gtk-icon-theme-name="breeze"
    gtk-fallback-icon-theme="hicolor"
    gtk-cursor-theme-name="breeze_cursors"
    gtk-toolbar-style=GTK_TOOLBAR_ICONS
    gtk-menu-images=1
    gtk-button-images=1
  '';

  gtk3_settings = ini.generate "settings.ini" {
    Settings = {
      gtk-font-name = "Sans Serif Regular 10";
      gtk-theme-name = "Breeze";
      gtk-icon-theme-name = "breeze";
      gtk-fallback-icon-theme = "hicolor";
      gtk-cursor-theme-name = "breeze_cursors";
      gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
      gtk-menu-images = 1;
      gtk-button-images = 1;
    };
  };

  kcminputrc = ini.generate "kcminputrc" {
    Mouse = {
      cursorTheme = "breeze_cursors";
      cursorSize = 0;
    };
  };

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
        ${sed} -i "$trolltech_conf" -e '/nix\\store\|nix\/store/ d'
    fi

    # Remove the kbuildsyscoca5 cache. It will be regenerated
    # immediately after. This is necessary for kbuildsyscoca5 to
    # recognize that software that has been removed.
    rm -fv $HOME/.cache/ksycoca*

    ${libsForQt5.kservice}/bin/kbuildsycoca5
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

  startplasma =
    ''
      ${set_XDG_CONFIG_HOME}
      mkdir -p "''${XDG_CONFIG_HOME}"

    ''
    + optionalString pulseaudio.enable ''
      # Load PulseAudio module for routing support.
      # See also: http://colin.guthr.ie/2009/10/so-how-does-the-kde-pulseaudio-support-work-anyway/
        ${pactl} load-module module-device-manager "do_routing=1"

    ''
    + ''
      ${activationScript}

      # Create default configurations if Plasma has never been started.
      kdeglobals="''${XDG_CONFIG_HOME}/kdeglobals"
      if ! [ -f "$kdeglobals" ]
      then
          kcminputrc="''${XDG_CONFIG_HOME}/kcminputrc"
          if ! [ -f "$kcminputrc" ]; then
              cat ${kcminputrc} >"$kcminputrc"
          fi

          gtkrc2="$HOME/.gtkrc-2.0"
          if ! [ -f "$gtkrc2" ]; then
              cat ${gtkrc2} >"$gtkrc2"
          fi

          gtk3_settings="''${XDG_CONFIG_HOME}/gtk-3.0/settings.ini"
          if ! [ -f "$gtk3_settings" ]; then
              mkdir -p "$(dirname "$gtk3_settings")"
              cat ${gtk3_settings} >"$gtk3_settings"
          fi
      fi

    '';

in

{
  options.services.xserver.desktopManager.plasma5 = {
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

    supportDDC = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Support setting monitor brightness via DDC.
        </para>
        <para>
        This is not needed for controlling brightness of the internal monitor
        of a laptop and as it is considered experimental by upstream, it is
        disabled by default.
      '';
    };

    useQtScaling = mkOption {
      type = types.bool;
      default = false;
      description = "Enable HiDPI scaling in Qt.";
    };

    runUsingSystemd = mkOption {
      description = "Use systemd to manage the Plasma session";
      type = types.bool;
      default = false;
    };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "xserver" "desktopManager" "plasma5" "enableQt4Support" ] "Phonon no longer supports Qt 4.")
    (mkRenamedOptionModule [ "services" "xserver" "desktopManager" "kde5" ] [ "services" "xserver" "desktopManager" "plasma5" ])
  ];

  config = mkMerge [
    (mkIf cfg.enable {

      # Seed our configuration into nixos-generate-config
      system.nixos-generate-config.desktopConfiguration = [
        ''
          # Enable the Plasma 5 Desktop Environment.
          services.xserver.displayManager.sddm.enable = true;
          services.xserver.desktopManager.plasma5.enable = true;
        ''
      ];

      services.xserver.displayManager.sessionPackages = [ pkgs.libsForQt5.plasma5.plasma-workspace ];

      security.wrappers = {
        kcheckpass =
          {
            setuid = true;
            owner = "root";
            group = "root";
            source = "${getBin libsForQt5.kscreenlocker}/libexec/kcheckpass";
          };
        start_kdeinit =
          {
            setuid = true;
            owner = "root";
            group = "root";
            source = "${getBin libsForQt5.kinit}/libexec/kf5/start_kdeinit";
          };
        kwin_wayland =
          {
            owner = "root";
            group = "root";
            capabilities = "cap_sys_nice+ep";
            source = "${getBin plasma5.kwin}/bin/kwin_wayland";
          };
      };

      # DDC support
      boot.kernelModules = lib.optional cfg.supportDDC "i2c_dev";
      services.udev.extraRules = lib.optionalString cfg.supportDDC ''
        KERNEL=="i2c-[0-9]*", TAG+="uaccess"
      '';

      environment.systemPackages =
        with libsForQt5;
        with plasma5; with kdeGear; with kdeFrameworks;
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
          kinfocenter
          kmenuedit
          kscreen
          kscreenlocker
          ksystemstats
          kwayland
          kwin
          kwrited
          libkscreen
          libksysguard
          milou
          plasma-systemmonitor
          plasma-browser-integration
          plasma-integration
          polkit-kde-agent
          spectacle
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

          kde-gtk-config
          breeze-gtk

          qtvirtualkeyboard

          pkgs.xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/

          elisa
          gwenview
          okular
        ]

        # Phonon audio backend
        ++ lib.optional (cfg.phononBackend == "gstreamer") libsForQt5.phonon-backend-gstreamer
        ++ lib.optional (cfg.phononBackend == "vlc") libsForQt5.phonon-backend-vlc

        # Optional hardware support features
        ++ lib.optionals config.hardware.bluetooth.enable [ bluedevil bluez-qt pkgs.openobex pkgs.obexftp ]
        ++ lib.optional config.networking.networkmanager.enable plasma-nm
        ++ lib.optional config.hardware.pulseaudio.enable plasma-pa
        ++ lib.optional config.services.pipewire.pulse.enable plasma-pa
        ++ lib.optional config.powerManagement.enable powerdevil
        ++ lib.optional config.services.colord.enable pkgs.colord-kde
        ++ lib.optional config.services.hardware.bolt.enable pkgs.plasma5Packages.plasma-thunderbolt
        ++ lib.optionals config.services.samba.enable [ kdenetwork-filesharing pkgs.samba ]
        ++ lib.optional config.services.xserver.wacom.enable pkgs.wacomtablet;

      environment.pathsToLink = [
        # FIXME: modules should link subdirs of `/share` rather than relying on this
        "/share"
      ];

      environment.etc."X11/xkb".source = xcfg.xkbDir;

      environment.sessionVariables.PLASMA_USE_QT_SCALING = mkIf cfg.useQtScaling "1";

      # Enable GTK applications to load SVG icons
      services.xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

      fonts.fonts = with pkgs; [ noto-fonts hack-font ];
      fonts.fontconfig.defaultFonts = {
        monospace = [ "Hack" "Noto Sans Mono" ];
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

      systemd.user.services = {
        plasma-early-setup = mkIf cfg.runUsingSystemd {
          description = "Early Plasma setup";
          wantedBy = [ "graphical-session-pre.target" ];
          serviceConfig.Type = "oneshot";
          script = activationScript;
        };

        plasma-run-with-systemd = {
          description = "Run KDE Plasma via systemd";
          wantedBy = [ "basic.target" ];
          serviceConfig.Type = "oneshot";
          script = ''
            ${set_XDG_CONFIG_HOME}

            ${kdeFrameworks.kconfig}/bin/kwriteconfig5 \
              --file startkderc --group General --key systemdBoot ${lib.boolToString cfg.runUsingSystemd}
          '';
        };
      };

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [ plasma5.xdg-desktop-portal-kde ];

      # Update the start menu for each user that is currently logged in
      system.userActivationScripts.plasmaSetup = activationScript;
      services.xserver.displayManager.setupCommands = startplasma;

      nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
    })
  ];

}
