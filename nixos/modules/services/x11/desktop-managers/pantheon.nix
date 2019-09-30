{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.pantheon;

  nixos-gsettings-desktop-schemas = pkgs.pantheon.elementary-gsettings-schemas.override {
    extraGSettingsOverridePackages = cfg.extraGSettingsOverridePackages;
    extraGSettingsOverrides = cfg.extraGSettingsOverrides;
  };

in

{

  meta.maintainers = pkgs.pantheon.maintainers;

  options = {

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


  config = mkIf cfg.enable {

    services.xserver.displayManager.extraSessionFilePackages = [ pkgs.pantheon.elementary-session-settings ];

    # Ensure lightdm is used when Pantheon is enabled
    # Without it screen locking will be nonfunctional because of the use of lightlocker

    warnings = optional (config.services.xserver.displayManager.lightdm.enable != true)
      ''
        Using Pantheon without LightDM as a displayManager will break screenlocking from the UI.
      '';

    services.xserver.displayManager.lightdm.greeters.pantheon.enable = mkDefault true;

    # If not set manually Pantheon session cannot be started
    # Known issue of https://github.com/NixOS/nixpkgs/pull/43992
    services.xserver.desktopManager.default = mkForce "pantheon";

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

    hardware.bluetooth.enable = mkDefault true;
    hardware.pulseaudio.enable = mkDefault true;
    security.polkit.enable = true;
    services.accounts-daemon.enable = true;
    services.bamf.enable = true;
    services.colord.enable = mkDefault true;
    services.pantheon.files.enable = mkDefault true;
    services.tumbler.enable = mkDefault true;
    services.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));
    services.dbus.packages = [
      pkgs.pantheon.switchboard-plug-power
    ];
    services.pantheon.contractor.enable = mkDefault true;
    services.gnome3.at-spi2-core.enable = true;
    services.gnome3.evolution-data-server.enable = true;
    services.gnome3.glib-networking.enable = true;
    # TODO: gnome-keyring's xdg autostarts will still be in the environment (from elementary-session-settings) if disabled forcefully
    services.gnome3.gnome-keyring.enable = true;
    services.gnome3.gnome-settings-daemon.enable = true;
    services.udev.packages = [ pkgs.pantheon.elementary-settings-daemon ];
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

    programs.dconf.enable = true;
    programs.evince.enable = mkDefault true;
    programs.file-roller.enable = mkDefault true;
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

    networking.networkmanager.enable = mkDefault true;

    # Override GSettings schemas
    environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

    environment.sessionVariables.GNOME_SESSION_DEBUG = optionalString cfg.debug "1";

    # Settings from elementary-default-settings
    environment.sessionVariables.GTK_CSD = "1";
    environment.sessionVariables.GTK_MODULES = "pantheon-filechooser-module";
    environment.etc."gtk-3.0/settings.ini".source = "${pkgs.pantheon.elementary-default-settings}/etc/gtk-3.0/settings.ini";

    environment.pathsToLink = [
      # FIXME: modules should link subdirs of `/share` rather than relying on this
      "/share"
    ];

    environment.systemPackages =
      pkgs.pantheon.artwork ++ pkgs.pantheon.desktop ++ pkgs.pantheon.services ++ cfg.sessionPath
      ++ (with pkgs; gnome3.removePackagesByName
      ([
        gnome3.geary
        gnome3.epiphany
        gnome3.gnome-font-viewer
      ] ++ pantheon.apps) config.environment.pantheon.excludePackages)
      ++ (with pkgs;
      [
        adwaita-qt
        desktop-file-utils
        glib
        glib-networking
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
      ]);

    fonts.fonts = with pkgs; [
      open-sans
      roboto-mono
      pantheon.elementary-redacted-script # needed by screenshot-tool
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = [ "Roboto Mono" ];
      sansSerif = [ "Open Sans" ];
    };

  };

}
