{ config, lib, pkgs, utils, ... }:

with lib;

let
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.deepin;

  nixos-gsettings-overrides = pkgs.deepin.dde-gsettings-schemas.override {
    extraGSettingsOverridePackages = cfg.extraGSettingsOverridePackages;
    extraGSettingsOverrides = cfg.extraGSettingsOverrides;
  };
in
{
  options = {

    services.xserver.desktopManager.deepin = {
      enable = mkEnableOption "Deepin desktop manager";
      extraGSettingsOverrides = mkOption {
        default = "";
        type = types.lines;
        description = "Additional gsettings overrides.";
      };
      extraGSettingsOverridePackages = mkOption {
        default = [ ];
        type = types.listOf types.path;
        description = "List of packages for which gsettings are overridden.";
      };
    };

    environment.deepin.excludePackages = mkOption {
      default = [ ];
      type = types.listOf types.package;
      description = "List of default packages to exclude from the configuration";
    };

  };

  config = mkIf cfg.enable
    {
      services.displayManager.sessionPackages = [ pkgs.deepin.dde-session ];
      services.displayManager.defaultSession = mkDefault "dde-x11";

      # Update the DBus activation environment after launching the desktop manager.
      services.xserver.displayManager.sessionCommands = ''
        ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
      '';

      hardware.bluetooth.enable = mkDefault true;
      security.polkit.enable = true;

      services.deepin.dde-daemon.enable = mkForce true;
      services.deepin.dde-api.enable = mkForce true;
      services.deepin.app-services.enable = mkForce true;
      services.deepin.deepin-anything.enable = mkDefault true;

      services.colord.enable = mkDefault true;
      services.accounts-daemon.enable = mkDefault true;
      services.gvfs.enable = mkDefault true;
      services.gnome.glib-networking.enable = mkDefault true;
      services.gnome.gnome-keyring.enable = mkDefault true;
      services.bamf.enable = mkDefault true;

      services.libinput.enable = mkDefault true;
      services.udisks2.enable = true;
      services.upower.enable = mkDefault config.powerManagement.enable;
      networking.networkmanager.enable = mkDefault true;
      programs.dconf.enable = mkDefault true;
      programs.gnupg.agent.pinentryPackage = mkDefault pkgs.pinentry-qt;

      fonts.packages = with pkgs; [ noto-fonts ];
      xdg.mime.enable = true;
      xdg.menus.enable = true;
      xdg.icons.enable = true;
      xdg.portal.enable = mkDefault true;
      xdg.portal.extraPortals = mkDefault [
        (pkgs.xdg-desktop-portal-gtk.override {
          buildPortalsInGnome = false;
        })
      ];

      # https://github.com/NixOS/nixpkgs/pull/247766#issuecomment-1722839259
      xdg.portal.config.deepin.default = mkDefault [ "gtk" ];

      environment.sessionVariables = {
        NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
        DDE_POLKIT_AGENT_PLUGINS_DIRS = [ "${pkgs.deepin.dpa-ext-gnomekeyring}/lib/polkit-1-dde/plugins" ];
      };

      environment.pathsToLink = [
        "/lib/dde-dock/plugins"
        "/lib/dde-control-center"
        "/lib/dde-session-shell"
        "/lib/dde-file-manager"
        "/share/backgrounds"
        "/share/wallpapers"
        "/share/dde-daemon"
        "/share/dsg"
        "/share/deepin-themes"
        "/share/deepin"
        "/share/dde-shell"
      ];

      environment.etc = {
        "deepin-installer.conf".text = ''
          system_info_vendor_name="Copyright (c) 2003-2024 NixOS contributors"
        '';
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/AccountsService 0775 root root - -"
        "C /var/lib/AccountsService/icons 0775 root root - ${pkgs.deepin.dde-account-faces}/var/lib/AccountsService/icons"
      ];

      security.pam.services.dde-lock.text = ''
        # original at {dde-session-shell}/etc/pam.d/dde-lock
        auth      substack      login
        account   include       login
        password  substack      login
        session   include       login
      '';

      environment.systemPackages = with pkgs; with deepin;
        let
          requiredPackages = [
            pciutils # for dtkcore/startdde
            xdotool # for dde-daemon
            glib # for gsettings program / gdbus
            gtk3 # for gtk-launch program
            xdg-user-dirs # Update user dirs
            util-linux # runuser
            polkit_gnome
            librsvg # dde-api use rsvg-convert
            lshw # for dtkcore
            libsForQt5.kde-gtk-config # deepin-api/gtk-thumbnailer need
            libsForQt5.kglobalaccel
            xsettingsd # lightdm-deepin-greeter
            dtkcommon
            dtkcore
            dtkgui
            dtkwidget
            dtkdeclarative
            qt5platform-plugins
            qt6platform-plugins
            qt5integration
            qt6integration
            deepin-pw-check

            dde-account-faces
            deepin-icon-theme
            deepin-desktop-theme
            deepin-sound-theme
            deepin-gtk-theme
            deepin-wallpapers
            deepin-desktop-base

            startdde
            dde-shell
            dde-launchpad
            dde-session-ui
            dde-session-shell
            dde-file-manager
            dde-control-center
            dde-network-core
            dde-clipboard
            dde-calendar
            dde-polkit-agent
            dpa-ext-gnomekeyring
            deepin-desktop-schemas
            deepin-terminal
            deepin-kwin
            dde-session
            dde-widgets
            dde-appearance
            dde-application-manager
            deepin-service-manager
            dde-grand-search
            dde-api-proxy
            dde-tray-loader
          ];
          optionalPackages = [
            onboard # dde-dock plugin
            deepin-calculator
            deepin-compressor
            deepin-editor
            deepin-picker
            deepin-draw
            deepin-music
            deepin-movie-reborn
            deepin-system-monitor
            deepin-shortcut-viewer
            # freeimage has knownVulnerabilties, don't install packages using freeiamge by default
            # deepin-album
            # deepin-camera
            # deepin-image-viewer
            # deepin-screen-recorder
          ];
        in
        requiredPackages
        ++ utils.removePackagesByName optionalPackages config.environment.deepin.excludePackages;

      services.dbus.packages = with pkgs.deepin; [
        dde-shell
        dde-launchpad
        dde-session-ui
        dde-session-shell
        dde-file-manager
        dde-control-center
        dde-calendar
        dde-clipboard
        deepin-kwin
        deepin-pw-check
        dde-widgets
        dde-session
        dde-appearance
        dde-application-manager
        deepin-service-manager
        dde-grand-search
        dde-api-proxy
      ];

      systemd.packages = with pkgs.deepin; [
        dde-shell
        dde-launchpad
        dde-file-manager
        dde-calendar
        dde-clipboard
        deepin-kwin
        dde-appearance
        dde-widgets
        dde-session
        dde-application-manager
        deepin-service-manager
        dde-api-proxy
      ];
    };
}

