{ config, lib, pkgs, utils, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.cinnamon;
  serviceCfg = config.services.cinnamon;

  nixos-gsettings-overrides = pkgs.cinnamon.cinnamon-gsettings-overrides.override {
    extraGSettingsOverridePackages = cfg.extraGSettingsOverridePackages;
    extraGSettingsOverrides = cfg.extraGSettingsOverrides;
  };

  notExcluded = pkg: (!(lib.elem pkg config.environment.cinnamon.excludePackages));
in

{
  options = {
    services.cinnamon = {
      apps.enable = mkEnableOption (lib.mdDoc "Cinnamon default applications");
    };

    services.xserver.desktopManager.cinnamon = {
      enable = mkEnableOption (lib.mdDoc "the cinnamon desktop manager");

      sessionPath = mkOption {
        default = [];
        type = types.listOf types.package;
        example = literalExpression "[ pkgs.gnome.gpaste ]";
        description = lib.mdDoc ''
          Additional list of packages to be added to the session search path.
          Useful for GSettings-conditional autostart.

          Note that this should be a last resort; patching the package is preferred (see GPaste).
        '';
      };

      extraGSettingsOverrides = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc "Additional gsettings overrides.";
      };

      extraGSettingsOverridePackages = mkOption {
        default = [];
        type = types.listOf types.path;
        description = lib.mdDoc "List of packages for which gsettings are overridden.";
      };
    };

    environment.cinnamon.excludePackages = mkOption {
      default = [];
      example = literalExpression "[ pkgs.cinnamon.blueberry ]";
      type = types.listOf types.package;
      description = lib.mdDoc "Which packages cinnamon should exclude from the default environment";
    };

  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.xserver.displayManager.sessionPackages = [ pkgs.cinnamon.cinnamon-common ];

      services.xserver.displayManager.lightdm.greeters.slick = {
        enable = mkDefault true;

        # Taken from mint-artwork.gschema.override
        theme = mkIf (notExcluded pkgs.cinnamon.mint-themes) {
          name = mkDefault "Mint-Y-Aqua";
          package = mkDefault pkgs.cinnamon.mint-themes;
        };
        iconTheme = mkIf (notExcluded pkgs.cinnamon.mint-x-icons) {
          name = mkDefault "Mint-Y-Aqua";
          package = mkDefault pkgs.cinnamon.mint-x-icons;
        };
        cursorTheme = mkIf (notExcluded pkgs.cinnamon.mint-cursor-themes) {
          name = mkDefault "Bibata-Modern-Classic";
          package = mkDefault pkgs.cinnamon.mint-cursor-themes;
        };
      };
      services.xserver.displayManager.sessionCommands = ''
        if test "$XDG_CURRENT_DESKTOP" = "Cinnamon"; then
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
      services.blueman.enable = mkDefault true;
      hardware.bluetooth.enable = mkDefault true;
      hardware.pulseaudio.enable = mkDefault true;
      security.polkit.enable = true;
      services.accounts-daemon.enable = true;
      services.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));
      services.dbus.packages = with pkgs.cinnamon; [
        cinnamon-common
        cinnamon-screensaver
        nemo-with-extensions
        xapp
      ];
      services.cinnamon.apps.enable = mkDefault true;
      services.gnome.glib-networking.enable = true;
      services.gnome.gnome-keyring.enable = true;
      services.gvfs.enable = true;
      services.udisks2.enable = true;
      services.upower.enable = mkDefault config.powerManagement.enable;
      services.xserver.libinput.enable = mkDefault true;
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

      environment.systemPackages = with pkgs.cinnamon // pkgs; ([
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
        cinnamon-control-center
        cinnamon-settings-daemon
        libgnomekbd

        # theme
        gnome.adwaita-icon-theme
        gnome.gnome-themes-extra
        gtk3.out

        # other
        glib # for gsettings
        xdg-user-dirs
      ] ++ utils.removePackagesByName [
        # accessibility
        onboard
        orca

        # theme
        sound-theme-freedesktop
        nixos-artwork.wallpapers.simple-dark-gray
        mint-artwork
        mint-cursor-themes
        mint-themes
        mint-x-icons
        mint-y-icons
        xapp # provides some xapp-* icons
      ] config.environment.cinnamon.excludePackages);

      xdg.mime.enable = true;
      xdg.icons.enable = true;

      # Override GSettings schemas
      environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

      environment.pathsToLink = [
        # FIXME: modules should link subdirs of `/share` rather than relying on this
        "/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
      ];

      # Shell integration for VTE terminals
      programs.bash.vteIntegration = mkDefault true;
      programs.zsh.vteIntegration = mkDefault true;

      # Harmonize Qt5 applications under Cinnamon
      qt5.enable = true;
      qt5.platformTheme = "gnome";
      qt5.style = "adwaita";

      # Default Fonts
      fonts.fonts = with pkgs; [
        source-code-pro # Default monospace font in 3.32
        ubuntu_font_family # required for default theme
      ];
    })

    (mkIf serviceCfg.apps.enable {
      programs.geary.enable = mkDefault true;
      programs.gnome-disks.enable = mkDefault true;
      programs.gnome-terminal.enable = mkDefault true;
      programs.evince.enable = mkDefault true;
      programs.file-roller.enable = mkDefault true;

      environment.systemPackages = with pkgs // pkgs.gnome // pkgs.cinnamon; utils.removePackagesByName [
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
        hexchat
        gnome-calculator
        gnome-screenshot
      ] config.environment.cinnamon.excludePackages;
    })
  ];
}
