{ lib, pkgs, config, utils, ... }:

let
  inherit (lib) concatMapStrings literalExpression mdDoc mkDefault mkEnableOption mkIf mkOption types;

  cfg = config.services.xserver.desktopManager.budgie;

  nixos-background-light = pkgs.nixos-artwork.wallpapers.nineish;
  nixos-background-dark = pkgs.nixos-artwork.wallpapers.nineish-dark-gray;

  nixos-gsettings-overrides = pkgs.budgie.budgie-gsettings-overrides.override {
    inherit (cfg) extraGSettingsOverrides extraGSettingsOverridePackages;
    inherit nixos-background-dark nixos-background-light;
  };

  nixos-background-info = pkgs.writeTextFile {
    name = "nixos-background-info";
    text = ''
      <?xml version="1.0"?>
      <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
      <wallpapers>
        <wallpaper deleted="false">
          <name>Nineish</name>
          <filename>${nixos-background-light.gnomeFilePath}</filename>
          <options>zoom</options>
          <shade_type>solid</shade_type>
          <pcolor>#d1dcf8</pcolor>
          <scolor>#e3ebfe</scolor>
        </wallpaper>
        <wallpaper deleted="false">
          <name>Nineish Dark Gray</name>
          <filename>${nixos-background-dark.gnomeFilePath}</filename>
          <options>zoom</options>
          <shade_type>solid</shade_type>
          <pcolor>#151515</pcolor>
          <scolor>#262626</scolor>
        </wallpaper>
      </wallpapers>
    '';
    destination = "/share/gnome-background-properties/nixos.xml";
  };
in {
  options = {
    services.xserver.desktopManager.budgie = {
      enable = mkEnableOption (mdDoc "the Budgie desktop");

      sessionPath = mkOption {
        description = mdDoc "Additional list of packages to be added to the session search path. Useful for GSettings-conditional autostart.";
        type = with types; listOf package;
        example = literalExpression "[ pkgs.budgie.budgie-desktop-view ]";
        default = [];
      };

      extraGSettingsOverrides = mkOption {
        description = mdDoc "Additional GSettings overrides.";
        type = types.lines;
        default = "";
      };

      extraGSettingsOverridePackages = mkOption {
        description = mdDoc "List of packages for which GSettings are overridden.";
        type = with types; listOf path;
        default = [];
      };

      extraPlugins = mkOption {
        description = mdDoc "Extra plugins for the Budgie desktop";
        type = with types; listOf package;
        default = [];
      };
    };

    environment.budgie.excludePackages = mkOption {
      description = mdDoc "Which packages Budgie should exclude from the default environment.";
      type = with types; listOf package;
      default = [];
      example = literalExpression "[ pkgs.mate-terminal ]";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.sessionPackages = with pkgs; [
      budgie.budgie-desktop
    ];

    services.xserver.displayManager.lightdm.greeters.slick = {
      enable = mkDefault true;
      theme = mkDefault { name = "Qogir"; package = pkgs.qogir-theme; };
      iconTheme = mkDefault { name = "Qogir"; package = pkgs.qogir-icon-theme; };
      cursorTheme = mkDefault { name = "Qogir"; package = pkgs.qogir-icon-theme; };
    };

    services.xserver.desktopManager.budgie.sessionPath = [ pkgs.budgie.budgie-desktop-view ];

    environment.extraInit = ''
      ${concatMapStrings (p: ''
        if [ -d "${p}/share/gsettings-schemas/${p.name}" ]; then
          export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${p}/share/gsettings-schemas/${p.name}
        fi
        if [ -d "${p}/lib/girepository-1.0" ]; then
          export GI_TYPELIB_PATH=$GI_TYPELIB_PATH''${GI_TYPELIB_PATH:+:}${p}/lib/girepository-1.0
          export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${p}/lib
        fi
      '') cfg.sessionPath}
    '';

    environment.systemPackages = with pkgs;
      [
        # Budgie Desktop.
        budgie.budgie-backgrounds
        budgie.budgie-control-center
        (budgie.budgie-desktop-with-plugins.override { plugins = cfg.extraPlugins; })
        budgie.budgie-desktop-view
        budgie.budgie-screensaver

        # Required by the Budgie Desktop session.
        (gnome.gnome-session.override { gnomeShellSupport = false; })

        # Required by Budgie Menu.
        gnome-menus

        # Required by Budgie Control Center.
        gnome.zenity

        # Provides `gsettings`.
        glib

        # Update user directories.
        xdg-user-dirs
      ]
      ++ (utils.removePackagesByName [
          cinnamon.nemo
          mate.eom
          mate.pluma
          mate.atril
          mate.engrampa
          mate.mate-calc
          mate.mate-terminal
          mate.mate-system-monitor
          vlc

          # Desktop themes.
          qogir-theme
          qogir-icon-theme
          nixos-background-info

          # Default settings.
          nixos-gsettings-overrides
        ] config.environment.budgie.excludePackages)
      ++ cfg.sessionPath;

    # Fonts.
    fonts.fonts = mkDefault [
      pkgs.noto-fonts
      pkgs.hack-font
    ];
    fonts.fontconfig.defaultFonts = {
      sansSerif = mkDefault ["Noto Sans"];
      monospace = mkDefault ["Hack"];
    };

    # Qt application style.
    qt = {
      enable = mkDefault true;
      style = mkDefault "gtk2";
      platformTheme = mkDefault "gtk2";
    };

    environment.pathsToLink = [
      "/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
    ];

    # GSettings overrides.
    environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

    # Required by Budgie Desktop.
    services.xserver.updateDbusEnvironment = true;
    programs.dconf.enable = true;

    # Required by Budgie Screensaver.
    security.pam.services.budgie-screensaver = {};

    # Required by Budgie's Polkit Dialog.
    security.polkit.enable = mkDefault true;

    # Required by Budgie Panel plugins and/or Budgie Control Center panels.
    networking.networkmanager.enable = mkDefault true; # for BCC's Network panel.
    programs.nm-applet.enable = config.networking.networkmanager.enable; # Budgie has no Network applet.
    programs.nm-applet.indicator = false; # Budgie doesn't support AppIndicators.

    hardware.bluetooth.enable = mkDefault true; # for Budgie's Status Indicator and BCC's Bluetooth panel.
    hardware.pulseaudio.enable = mkDefault true; # for Budgie's Status Indicator and BCC's Sound panel.

    xdg.portal.enable = mkDefault true; # for BCC's Applications panel.
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gtk # provides a XDG Portals implementation.
    ];

    services.geoclue2.enable = mkDefault true; # for BCC's Privacy > Location Services panel.
    services.upower.enable = config.powerManagement.enable; # for Budgie's Status Indicator and BCC's Power panel.
    services.xserver.libinput.enable = mkDefault true; # for BCC's Mouse panel.
    services.colord.enable = mkDefault true; # for BCC's Color panel.
    services.gnome.at-spi2-core.enable = mkDefault true; # for BCC's A11y panel.
    services.accounts-daemon.enable = mkDefault true; # for BCC's Users panel.
    services.fprintd.enable = mkDefault true; # for BCC's Users panel.
    services.udisks2.enable = mkDefault true; # for BCC's Details panel.

    # For BCC's Online Accounts panel.
    services.gnome.gnome-online-accounts.enable = mkDefault true;
    services.gnome.gnome-online-miners.enable = true;

    # For BCC's Printers panel.
    services.printing.enable = mkDefault true;
    services.system-config-printer.enable = config.services.printing.enable;

    # For BCC's Sharing panel.
    services.dleyna-renderer.enable = mkDefault true;
    services.dleyna-server.enable = mkDefault true;
    services.gnome.gnome-user-share.enable = mkDefault true;
    services.gnome.rygel.enable = mkDefault true;

    # Other default services.
    services.gnome.evolution-data-server.enable = mkDefault true;
    services.gnome.glib-networking.enable = mkDefault true;
    services.gnome.gnome-keyring.enable = mkDefault true;
    services.gnome.gnome-settings-daemon.enable = mkDefault true;
    services.gvfs.enable = mkDefault true;

    # Register packages for DBus.
    services.dbus.packages = with pkgs; [
      budgie.budgie-control-center
    ];

    # Shell integration for MATE Terminal.
    programs.bash.vteIntegration = true;
    programs.zsh.vteIntegration = true;
  };
}
