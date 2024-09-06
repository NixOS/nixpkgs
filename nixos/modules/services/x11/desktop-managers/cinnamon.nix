{ config, lib, pkgs, utils, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.cinnamon;
  serviceCfg = config.services.cinnamon;

  nixos-gsettings-overrides = pkgs.cinnamon-gsettings-overrides.override {
    extraGSettingsOverridePackages = cfg.extraGSettingsOverridePackages;
    extraGSettingsOverrides = cfg.extraGSettingsOverrides;
  };

  notExcluded = pkg: (!(lib.elem pkg config.environment.cinnamon.excludePackages));
in

{
  options = {
    services.cinnamon = {
      apps.enable = mkEnableOption "Cinnamon default applications";
    };

    services.xserver.desktopManager.cinnamon = {
      enable = mkEnableOption "the cinnamon desktop manager";

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
    };

    environment.cinnamon.excludePackages = mkOption {
      default = [];
      example = literalExpression "[ pkgs.blueman ]";
      type = types.listOf types.package;
      description = "Which packages cinnamon should exclude from the default environment";
    };

  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.displayManager.sessionPackages = [ pkgs.cinnamon-common ];

      services.xserver.displayManager.lightdm.greeters.slick = {
        enable = mkDefault true;

        # Taken from mint-artwork.gschema.override
        theme = mkIf (notExcluded pkgs.mint-themes) {
          name = mkDefault "Mint-Y-Aqua";
          package = mkDefault pkgs.mint-themes;
        };
        iconTheme = mkIf (notExcluded pkgs.mint-y-icons) {
          name = mkDefault "Mint-Y-Sand";
          package = mkDefault pkgs.mint-y-icons;
        };
        cursorTheme = mkIf (notExcluded pkgs.mint-cursor-themes) {
          name = mkDefault "Bibata-Modern-Classic";
          package = mkDefault pkgs.mint-cursor-themes;
        };
      };

      # Have to take care of GDM + Cinnamon on Wayland users
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

      # Default services
      services.blueman.enable = mkDefault (notExcluded pkgs.blueman);
      hardware.bluetooth.enable = mkDefault true;
      security.polkit.enable = true;
      services.accounts-daemon.enable = true;
      services.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));
      services.dbus.packages = with pkgs; [
        cinnamon-common
        cinnamon-screensaver
        nemo-with-extensions
        xapp
      ];
      services.cinnamon.apps.enable = mkDefault true;
      services.gnome.evolution-data-server.enable = true;
      services.gnome.glib-networking.enable = true;
      services.gnome.gnome-keyring.enable = true;
      services.gvfs.enable = true;
      services.switcherooControl.enable = mkDefault true; # xapp-gpu-offload-helper
      services.touchegg.enable = mkDefault true;
      services.udisks2.enable = true;
      services.upower.enable = mkDefault config.powerManagement.enable;
      services.libinput.enable = mkDefault true;
      services.xserver.updateDbusEnvironment = true;
      networking.networkmanager.enable = mkDefault true;

      # Enable colord server
      services.colord.enable = true;

      # Enable dconf
      programs.dconf.enable = true;

      # Enable org.a11y.Bus
      services.gnome.at-spi2-core.enable = true;

      # Fix lockscreen
      security.pam.services = {
        cinnamon-screensaver = {};
      };

      environment.systemPackages = with pkgs; ([
        desktop-file-utils

        # common-files
        cinnamon-common
        cinnamon-session
        cinnamon-desktop
        cinnamon-menus
        cinnamon-translations

        # utils needed by some scripts
        killall

        # session requirements
        cinnamon-screensaver
        # cinnamon-killer-daemon: provided by cinnamon-common
        networkmanagerapplet # session requirement - also nm-applet not needed

        # For a polkit authentication agent
        polkit_gnome

        # packages
        nemo-with-extensions
        gnome-online-accounts-gtk
        cinnamon-control-center
        cinnamon-settings-daemon
        libgnomekbd

        # theme
        adwaita-icon-theme
        gnome-themes-extra
        gtk3.out

        # other
        glib # for gsettings
        xdg-user-dirs
      ] ++ utils.removePackagesByName [
        # accessibility
        onboard

        # theme
        sound-theme-freedesktop
        nixos-artwork.wallpapers.simple-dark-gray
        mint-artwork
        mint-cursor-themes
        mint-l-icons
        mint-l-theme
        mint-themes
        mint-x-icons
        mint-y-icons
        xapp # provides some xapp-* icons
      ] config.environment.cinnamon.excludePackages);

      xdg.mime.enable = true;
      xdg.icons.enable = true;

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-xapp
        (pkgs.xdg-desktop-portal-gtk.override {
          # Do not build portals that we already have.
          buildPortalsInGnome = false;
        })
      ];

      services.orca.enable = mkDefault (notExcluded pkgs.orca);

      xdg.portal.configPackages = mkDefault [ pkgs.cinnamon-common ];

      # Override GSettings schemas
      environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

      environment.pathsToLink = [
        # FIXME: modules should link subdirs of `/share` rather than relying on this
        "/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
      ];

      # Shell integration for VTE terminals
      programs.bash.vteIntegration = mkDefault true;
      programs.zsh.vteIntegration = mkDefault true;

      # Qt application style
      qt = {
        enable = mkDefault true;
        style = mkDefault "gtk2";
        platformTheme = mkDefault "gtk2";
      };

      # Default Fonts
      fonts.packages = with pkgs; [
        dejavu_fonts # Default monospace font in LMDE 6+
        ubuntu-classic # required for default theme
      ];
    })

    (mkIf serviceCfg.apps.enable {
      programs.gnome-disks.enable = mkDefault (notExcluded pkgs.gnome-disk-utility);
      programs.gnome-terminal.enable = mkDefault (notExcluded pkgs.gnome-terminal);
      programs.file-roller.enable = mkDefault (notExcluded pkgs.file-roller);

      environment.systemPackages = with pkgs; utils.removePackagesByName [
        # cinnamon team apps
        bulky
        warpinator

        # cinnamon xapp
        xviewer
        xreader
        xed-editor
        xplayer
        pix

        # external apps shipped with linux-mint
        gnome-calculator
        gnome-calendar
        gnome-screenshot
      ] config.environment.cinnamon.excludePackages;
    })
  ];
}
