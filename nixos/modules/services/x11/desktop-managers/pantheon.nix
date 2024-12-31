{ config, lib, utils, pkgs, ... }:
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
    maintainers = lib.teams.pantheon.members;
  };

  options = {

    services.pantheon = {

      contractor = {
         enable = lib.mkEnableOption "contractor, a desktop-wide extension service used by Pantheon";
      };

      apps.enable = lib.mkEnableOption "Pantheon default applications";

    };

    services.xserver.desktopManager.pantheon = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the pantheon desktop manager";
      };

      sessionPath = lib.mkOption {
        default = [];
        type = lib.types.listOf lib.types.package;
        example = lib.literalExpression "[ pkgs.gpaste ]";
        description = ''
          Additional list of packages to be added to the session search path.
          Useful for GSettings-conditional autostart.

          Note that this should be a last resort; patching the package is preferred (see GPaste).
        '';
      };

      extraWingpanelIndicators = lib.mkOption {
        default = null;
        type = with lib.types; nullOr (listOf package);
        description = "Indicators to add to Wingpanel.";
      };

      extraSwitchboardPlugs = lib.mkOption {
        default = null;
        type = with lib.types; nullOr (listOf package);
        description = "Plugs to add to Switchboard.";
      };

      extraGSettingsOverrides = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = "Additional gsettings overrides.";
      };

      extraGSettingsOverridePackages = lib.mkOption {
        default = [];
        type = lib.types.listOf lib.types.path;
        description = "List of packages for which gsettings are overridden.";
      };

      debug = lib.mkEnableOption "gnome-session debug messages";

    };

    environment.pantheon.excludePackages = lib.mkOption {
      default = [];
      example = lib.literalExpression "[ pkgs.pantheon.elementary-camera ]";
      type = lib.types.listOf lib.types.package;
      description = "Which packages pantheon should exclude from the default environment";
    };

  };


  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.xserver.desktopManager.pantheon.sessionPath = utils.removePackagesByName [
        pkgs.pantheon.pantheon-agent-geoclue2
      ] config.environment.pantheon.excludePackages;

      services.displayManager.sessionPackages = [ pkgs.pantheon.elementary-session-settings ];

      # Ensure lightdm is used when Pantheon is enabled
      # Without it screen locking will be nonfunctional because of the use of lightlocker
      warnings = lib.optional (config.services.xserver.displayManager.lightdm.enable != true)
        ''
          Using Pantheon without LightDM as a displayManager will break screenlocking from the UI.
        '';

      services.xserver.displayManager.lightdm.greeters.pantheon.enable = lib.mkDefault true;

      # Without this, elementary LightDM greeter will pre-select non-existent `default` session
      # https://github.com/elementary/greeter/issues/368
      services.displayManager.defaultSession = lib.mkDefault "pantheon";

      services.xserver.displayManager.sessionCommands = ''
        if test "$XDG_CURRENT_DESKTOP" = "Pantheon"; then
            true
            ${lib.concatMapStrings (p: ''
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
      hardware.bluetooth.enable = lib.mkDefault true;
      security.polkit.enable = true;
      services.accounts-daemon.enable = true;
      services.bamf.enable = true;
      services.colord.enable = lib.mkDefault true;
      services.fwupd.enable = lib.mkDefault true;
      # TODO: Enable once #177946 is resolved
      # services.packagekit.enable = mkDefault true;
      services.power-profiles-daemon.enable = lib.mkDefault true;
      services.touchegg.enable = lib.mkDefault true;
      services.touchegg.package = pkgs.pantheon.touchegg;
      services.tumbler.enable = lib.mkDefault true;
      services.system-config-printer.enable = (lib.mkIf config.services.printing.enable (lib.mkDefault true));
      services.dbus.packages = with pkgs.pantheon; [
        switchboard-plug-power
        elementary-default-settings # accountsservice extensions
      ];
      services.pantheon.apps.enable = lib.mkDefault true;
      services.pantheon.contractor.enable = lib.mkDefault true;
      services.gnome.at-spi2-core.enable = true;
      services.gnome.evolution-data-server.enable = true;
      services.gnome.glib-networking.enable = true;
      services.gnome.gnome-keyring.enable = true;
      services.gvfs.enable = true;
      services.gnome.rygel.enable = lib.mkDefault true;
      services.udisks2.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.libinput.enable = lib.mkDefault true;
      services.switcherooControl.enable = lib.mkDefault true;
      services.xserver.updateDbusEnvironment = true;
      services.zeitgeist.enable = lib.mkDefault true;
      services.geoclue2.enable = lib.mkDefault true;
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
      services.orca.enable = lib.mkDefault (notExcluded pkgs.orca);
      systemd.packages = with pkgs; [
        gnome-session
        pantheon.gala
        pantheon.gnome-settings-daemon
        pantheon.elementary-session-settings
      ];
      programs.dconf.enable = true;
      networking.networkmanager.enable = lib.mkDefault true;

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

      xdg.portal.configPackages = lib.mkDefault [ pkgs.pantheon.elementary-default-settings ];

      # Override GSettings schemas
      environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

      environment.sessionVariables.GNOME_SESSION_DEBUG = lib.mkIf cfg.debug "1";

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
      programs.bash.vteIntegration = lib.mkDefault true;
      programs.zsh.vteIntegration = lib.mkDefault true;

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

    (lib.mkIf serviceCfg.apps.enable {
      programs.evince.enable = lib.mkDefault (notExcluded pkgs.evince);
      programs.file-roller.enable = lib.mkDefault (notExcluded pkgs.file-roller);

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

    (lib.mkIf serviceCfg.contractor.enable {
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
