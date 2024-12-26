{ config, lib, utils, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.pantheon;
  serviceCfg = config.services.pantheon;

  nixos-gsettings-desktop-schemas = pkgs.pantheon.elementary-gsettings-schemas.override {
    extraGSettingsOverridePackages = cfg.extraGSettingsOverridePackages;
    extraGSettingsOverrides = cfg.extraGSettingsOverrides;
  };

  notExcluded = pkg: utils.disablePackageByName pkg config.environment.pantheon.excludePackages;
in

{

  meta = {
    doc = ./pantheon.md;
    maintainers = teams.pantheon.members;
  };

  options = {

    services.pantheon = {

      contractor = {
         enable = mkEnableOption "contractor, a desktop-wide extension service used by Pantheon";
      };

      apps.enable = mkEnableOption "Pantheon default applications";

    };

    services.xserver.desktopManager.pantheon = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the pantheon desktop manager";
      };

      sessionPath = mkOption {
        default = [];
        type = types.listOf types.package;
        example = literalExpression "[ pkgs.gpaste ]";
        description = ''
          Additional list of packages to be added to the session search path.
          Useful for GSettings-conditional autostart.

          Note that this should be a last resort; patching the package is preferred (see GPaste).
        '';
      };

      extraWingpanelIndicators = mkOption {
        default = null;
        type = with types; nullOr (listOf package);
        description = "Indicators to add to Wingpanel.";
      };

      extraSwitchboardPlugs = mkOption {
        default = null;
        type = with types; nullOr (listOf package);
        description = "Plugs to add to Switchboard.";
      };

      extraGSettingsOverrides = mkOption {
        default = "";
        type = types.lines;
        description = "Additional gsettings overrides.";
      };

      extraGSettingsOverridePackages = mkOption {
        default = [];
        type = types.listOf types.path;
        description = "List of packages for which gsettings are overridden.";
      };

      debug = mkEnableOption "gnome-session debug messages";

    };

    environment.pantheon.excludePackages = mkOption {
      default = [];
      example = literalExpression "[ pkgs.pantheon.elementary-camera ]";
      type = types.listOf types.package;
      description = "Which packages pantheon should exclude from the default environment";
    };

  };


  config = mkMerge [
    (mkIf cfg.enable {
      services.xserver.desktopManager.pantheon.sessionPath = utils.removePackagesByName [
        pkgs.pantheon.pantheon-agent-geoclue2
      ] config.environment.pantheon.excludePackages;

      services.displayManager.sessionPackages = [ pkgs.pantheon.elementary-session-settings ];

      # Ensure lightdm is used when Pantheon is enabled
      # Without it screen locking will be nonfunctional because of the use of lightlocker
      warnings = optional (config.services.xserver.displayManager.lightdm.enable != true)
        ''
          Using Pantheon without LightDM as a displayManager will break screenlocking from the UI.
        '';

      services.xserver.displayManager.lightdm.greeters.pantheon.enable = mkDefault true;

      # Without this, elementary LightDM greeter will pre-select non-existent `default` session
      # https://github.com/elementary/greeter/issues/368
      services.displayManager.defaultSession = mkDefault "pantheon";

      services.xserver.displayManager.sessionCommands = ''
        if test "$XDG_CURRENT_DESKTOP" = "Pantheon"; then
            true
            ${concatMapStrings (p: ''
              if [ -d "${p}/share/gsettings-schemas/${p.name}" ]; then
                export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${p}/share/gsettings-schemas/${p.name}
              fi

              if [ -d "${p}/lib/girepository-1.0" ]; then
                export GI_TYPELIB_PATH=$GI_TYPELIB_PATH''${GI_TYPELIB_PATH:+:}${p}/lib/girepository-1.0
                export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${p}/lib
              fi
            '') cfg.sessionPath}
        fi
      '';

      # Default services
      hardware.bluetooth.enable = mkDefault true;
      security.polkit.enable = true;
      services.accounts-daemon.enable = true;
      services.bamf.enable = true;
      services.colord.enable = mkDefault true;
      services.fwupd.enable = mkDefault true;
      # TODO: Enable once #177946 is resolved
      # services.packagekit.enable = mkDefault true;
      services.power-profiles-daemon.enable = mkDefault true;
      services.touchegg.enable = mkDefault true;
      services.touchegg.package = pkgs.pantheon.touchegg;
      services.tumbler.enable = mkDefault true;
      services.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));
      services.dbus.packages = with pkgs.pantheon; [
        switchboard-plug-power
        elementary-default-settings # accountsservice extensions
      ];
      services.pantheon.apps.enable = mkDefault true;
      services.pantheon.contractor.enable = mkDefault true;
      services.gnome.at-spi2-core.enable = true;
      services.gnome.evolution-data-server.enable = true;
      services.gnome.glib-networking.enable = true;
      services.gnome.gnome-keyring.enable = true;
      services.gvfs.enable = true;
      services.gnome.rygel.enable = mkDefault true;
      services.udisks2.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.libinput.enable = mkDefault true;
      services.switcherooControl.enable = mkDefault true;
      services.xserver.updateDbusEnvironment = true;
      services.zeitgeist.enable = mkDefault true;
      services.geoclue2.enable = mkDefault true;
      # pantheon has pantheon-agent-geoclue2
      services.geoclue2.enableDemoAgent = false;
      services.geoclue2.appConfig."io.elementary.desktop.agent-geoclue2" = {
        isAllowed = true;
        isSystem = true;
      };
      services.udev.packages = [
        pkgs.pantheon.gnome-settings-daemon
        # Force enable KMS modifiers for devices that require them.
        # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1443
        pkgs.pantheon.mutter
      ];
      services.orca.enable = mkDefault (notExcluded pkgs.orca);
      systemd.packages = with pkgs; [
        gnome-session
        pantheon.gala
        pantheon.gnome-settings-daemon
        pantheon.elementary-session-settings
      ];
      programs.dconf.enable = true;
      networking.networkmanager.enable = mkDefault true;

      systemd.user.targets."gnome-session-x11-services".wants = [
        "org.gnome.SettingsDaemon.XSettings.service"
      ];
      systemd.user.targets."gnome-session-x11-services-ready".wants = [
        "org.gnome.SettingsDaemon.XSettings.service"
      ];

      # Global environment
      environment.systemPackages = (with pkgs.pantheon; [
        elementary-bluetooth-daemon
        elementary-session-settings
        elementary-settings-daemon
        gala
        gnome-settings-daemon
        (switchboard-with-plugs.override {
          plugs = cfg.extraSwitchboardPlugs;
        })
        (wingpanel-with-indicators.override {
          indicators = cfg.extraWingpanelIndicators;
        })
      ]) ++ utils.removePackagesByName ((with pkgs; [
        desktop-file-utils
        glib # for gsettings program
        gnome-menus
        adwaita-icon-theme
        gtk3.out # for gtk-launch program
        onboard
        sound-theme-freedesktop
        xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
      ]) ++ (with pkgs.pantheon; [
        # Artwork
        elementary-gtk-theme
        elementary-icon-theme
        elementary-sound-theme
        elementary-wallpapers

        # Desktop
        elementary-default-settings
        elementary-dock
        elementary-shortcut-overlay

        # Services
        elementary-capnet-assist
        elementary-notifications
        pantheon-agent-geoclue2
        pantheon-agent-polkit
      ])) config.environment.pantheon.excludePackages;

      # Settings from elementary-default-settings
      environment.etc."gtk-3.0/settings.ini".source = "${pkgs.pantheon.elementary-default-settings}/etc/gtk-3.0/settings.ini";

      xdg.mime.enable = true;
      xdg.icons.enable = true;

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ] ++ (with pkgs.pantheon; [
        elementary-files
        elementary-settings-daemon
        xdg-desktop-portal-pantheon
      ]);

      xdg.portal.configPackages = mkDefault [ pkgs.pantheon.elementary-default-settings ];

      # Override GSettings schemas
      environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

      environment.sessionVariables.GNOME_SESSION_DEBUG = mkIf cfg.debug "1";

      environment.pathsToLink = [
        # FIXME: modules should link subdirs of `/share` rather than relying on this
        "/share"
      ];

      # Otherwise you can't store NetworkManager Secrets with
      # "Store the password only for this user"
      programs.nm-applet.enable = true;
      # Pantheon has its own network indicator
      programs.nm-applet.indicator = false;

      # Shell integration for VTE terminals
      programs.bash.vteIntegration = mkDefault true;
      programs.zsh.vteIntegration = mkDefault true;

      # Default Fonts
      fonts.packages = with pkgs; [
        inter
        open-dyslexic
        open-sans
        roboto-mono
      ];

      fonts.fontconfig.defaultFonts = {
        monospace = [ "Roboto Mono" ];
        sansSerif = [ "Inter" ];
      };
    })

    (mkIf serviceCfg.apps.enable {
      programs.evince.enable = mkDefault (notExcluded pkgs.evince);
      programs.file-roller.enable = mkDefault (notExcluded pkgs.file-roller);

      environment.systemPackages = utils.removePackagesByName ([
        pkgs.gnome-font-viewer
      ] ++ (with pkgs.pantheon; [
        elementary-calculator
        elementary-calendar
        elementary-camera
        elementary-code
        elementary-files
        elementary-mail
        elementary-music
        elementary-photos
        elementary-screenshot
        elementary-tasks
        elementary-terminal
        elementary-videos
        epiphany
      ] ++ lib.optionals config.services.flatpak.enable [
        # Only install appcenter if flatpak is enabled before
        # https://github.com/NixOS/nixpkgs/issues/15932 is resolved.
        appcenter
        sideload
      ])) config.environment.pantheon.excludePackages;

      # needed by screenshot
      fonts.packages = [
        pkgs.pantheon.elementary-redacted-script
      ];
    })

    (mkIf serviceCfg.contractor.enable {
      environment.systemPackages = with pkgs.pantheon; [
        contractor
        file-roller-contract
      ];

      environment.pathsToLink = [
        "/share/contractor"
      ];
    })

  ];
}
