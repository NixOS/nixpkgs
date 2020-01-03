{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.pantheon;
  serviceCfg = config.services.pantheon;

  nixos-gsettings-desktop-schemas = pkgs.pantheon.elementary-gsettings-schemas.override {
    extraGSettingsOverridePackages = cfg.extraGSettingsOverridePackages;
    extraGSettingsOverrides = cfg.extraGSettingsOverrides;
  };

in

{

  meta.maintainers = pkgs.pantheon.maintainers;

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
        example = literalExample "[ pkgs.gnome3.gpaste ]";
        description = ''
          Additional list of packages to be added to the session search path.
          Useful for GSettings-conditional autostart.

          Note that this should be a last resort; patching the package is preferred (see GPaste).
        '';
        apply = list: list ++
        [
          pkgs.pantheon.pantheon-agent-geoclue2
        ];
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
      example = literalExample "[ pkgs.pantheon.elementary-camera ]";
      type = types.listOf types.package;
      description = "Which packages pantheon should exclude from the default environment";
    };

  };


  config = mkMerge [
    (mkIf cfg.enable {

      services.xserver.displayManager.sessionPackages = [ pkgs.pantheon.elementary-session-settings ];

      # Ensure lightdm is used when Pantheon is enabled
      # Without it screen locking will be nonfunctional because of the use of lightlocker
      warnings = optional (config.services.xserver.displayManager.lightdm.enable != true)
        ''
          Using Pantheon without LightDM as a displayManager will break screenlocking from the UI.
        '';

      services.xserver.displayManager.lightdm.greeters.pantheon.enable = mkDefault true;

      # Without this, elementary LightDM greeter will pre-select non-existent `default` session
      # https://github.com/elementary/greeter/issues/368
      services.xserver.displayManager.defaultSession = "pantheon";

      services.xserver.displayManager.sessionCommands = ''
        if test "$XDG_CURRENT_DESKTOP" = "Pantheon"; then
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
      hardware.pulseaudio.enable = mkDefault true;
      security.polkit.enable = true;
      services.accounts-daemon.enable = true;
      services.bamf.enable = true;
      services.colord.enable = mkDefault true;
      services.tumbler.enable = mkDefault true;
      services.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));
      services.dbus.packages = with pkgs.pantheon; [
        switchboard-plug-power
        elementary-default-settings # accountsservice extensions
      ];
      services.pantheon.apps.enable = mkDefault true;
      services.pantheon.contractor.enable = mkDefault true;
      services.gnome3.at-spi2-core.enable = true;
      services.gnome3.evolution-data-server.enable = true;
      services.gnome3.glib-networking.enable = true;
      services.gnome3.gnome-keyring.enable = true;
      services.gvfs.enable = true;
      services.gnome3.rygel.enable = mkDefault true;
      services.gsignond.enable = mkDefault true;
      services.gsignond.plugins = with pkgs.gsignondPlugins; [ lastfm mail oauth ];
      services.udisks2.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.xserver.libinput.enable = mkDefault true;
      services.xserver.updateDbusEnvironment = true;
      services.zeitgeist.enable = mkDefault true;
      services.geoclue2.enable = mkDefault true;
      # pantheon has pantheon-agent-geoclue2
      services.geoclue2.enableDemoAgent = false;
      services.geoclue2.appConfig."io.elementary.desktop.agent-geoclue2" = {
        isAllowed = true;
        isSystem = true;
      };
      # Use gnome-settings-daemon fork
      services.udev.packages = [
        pkgs.pantheon.elementary-settings-daemon
      ];
      systemd.packages = [
        pkgs.pantheon.elementary-settings-daemon
      ];
      programs.dconf.enable = true;
      networking.networkmanager.enable = mkDefault true;

      # Global environment
      environment.systemPackages = with pkgs; [
        desktop-file-utils
        glib
        gnome-menus
        gnome3.adwaita-icon-theme
        gtk3.out
        hicolor-icon-theme
        lightlocker
        onboard
        plank
        qgnomeplatform
        shared-mime-info
        sound-theme-freedesktop
        xdg-user-dirs
      ] ++ (with pkgs.pantheon; [
        # Artwork
        elementary-gtk-theme
        elementary-icon-theme
        elementary-sound-theme
        elementary-wallpapers

        # Desktop
        elementary-default-settings
        elementary-session-settings
        elementary-shortcut-overlay
        gala
        (switchboard-with-plugs.override {
          plugs = cfg.extraSwitchboardPlugs;
        })
        (wingpanel-with-indicators.override {
          indicators = cfg.extraWingpanelIndicators;
        })

        # Services
        cerbere
        elementary-capnet-assist
        elementary-dpms-helper
        elementary-settings-daemon
        pantheon-agent-geoclue2
        pantheon-agent-polkit
      ]) ++ (gnome3.removePackagesByName [
        gnome3.geary
        gnome3.epiphany
        gnome3.gnome-font-viewer
      ] config.environment.pantheon.excludePackages);

      programs.evince.enable = mkDefault true;
      programs.file-roller.enable = mkDefault true;

      # Settings from elementary-default-settings
      environment.sessionVariables.GTK_CSD = "1";
      environment.sessionVariables.GTK3_MODULES = [ "pantheon-filechooser-module" ];
      environment.etc."gtk-3.0/settings.ini".source = "${pkgs.pantheon.elementary-default-settings}/etc/gtk-3.0/settings.ini";

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

      # Shell integration for VTE terminals
      programs.bash.vteIntegration = mkDefault true;
      programs.zsh.vteIntegration = mkDefault true;

      # Harmonize Qt5 applications under Pantheon
      qt5.enable = true;
      qt5.platformTheme = "gnome";
      qt5.style = "adwaita";

      # Default Fonts
      fonts.fonts = with pkgs; [
        open-sans
        roboto-mono
      ];

      fonts.fontconfig.defaultFonts = {
        monospace = [ "Roboto Mono" ];
        sansSerif = [ "Open Sans" ];
      };
    })

    (mkIf serviceCfg.apps.enable {
      environment.systemPackages = (with pkgs.pantheon; pkgs.gnome3.removePackagesByName [
        elementary-calculator
        elementary-calendar
        elementary-camera
        elementary-code
        elementary-files
        elementary-music
        elementary-photos
        elementary-screenshot-tool
        elementary-terminal
        elementary-videos
      ] config.environment.pantheon.excludePackages);

      # needed by screenshot-tool
      fonts.fonts = [
        pkgs.pantheon.elementary-redacted-script
      ];
    })

    (mkIf serviceCfg.contractor.enable {
      environment.systemPackages = with  pkgs.pantheon; [
        contractor
        extra-elementary-contracts
      ];

      environment.pathsToLink = [
        "/share/contractor"
      ];
    })

  ];
}
