{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.gnome3;
  gnome3 = config.environment.gnome3.packageSet;

  # Remove packages of ys from xs, based on their names
  removePackagesByName = xs: ys:
    let
      pkgName = drv: (builtins.parseDrvName drv.name).name;
      ysNames = map pkgName ys;
      res = (filter (x: !(builtins.elem (pkgName x) ysNames)) xs);
    in
      filter (x: !(builtins.elem (pkgName x) ysNames)) xs;

  # Prioritize nautilus by default when opening directories
  mimeAppsList = pkgs.writeTextFile {
    name = "gnome-mimeapps";
    destination = "/share/applications/mimeapps.list";
    text = ''
      [Default Applications]
      inode/directory=nautilus.desktop
    '';
  };

in {

  options = {

    services.xserver.desktopManager.gnome3.enable = mkOption {
      default = false;
      example = true;
      description = "Enable Gnome 3 desktop manager.";
    };

    environment.gnome3.packageSet = mkOption {
      default = pkgs.gnome3;
      example = literalExample "pkgs.gnome3_12";
      description = "Which Gnome 3 package set to use.";
    };
    
    environment.gnome3.excludePackages = mkOption {
      default = [];
      example = "[ pkgs.gnome3.totem ]";
      type = types.listOf types.package;
      description = "Which packages gnome should exclude from the default environment";
    };

  };

  config = mkIf cfg.enable {

    # Enable helpful DBus services.
    security.polkit.enable = true;
    services.udisks2.enable = true;
    services.accounts-daemon.enable = true;
    services.geoclue2.enable = mkDefault true;
    services.gnome3.at-spi2-core.enable = true;
    services.gnome3.evolution-data-server.enable = true;
    services.gnome3.gnome-documents.enable = mkDefault true;
    services.gnome3.gnome-keyring.enable = true;
    services.gnome3.gnome-online-accounts.enable = mkDefault true;
    services.gnome3.gnome-user-share.enable = mkDefault true;
    services.gnome3.gvfs.enable = true;
    services.gnome3.seahorse.enable = mkDefault true;
    services.gnome3.sushi.enable = mkDefault true;
    services.gnome3.tracker.enable = mkDefault true;
    hardware.pulseaudio.enable = mkDefault true;
    services.telepathy.enable = mkDefault true;
    networking.networkmanager.enable = true;
    services.upower.enable = config.powerManagement.enable;
    services.upower.package = gnome3.upower;

    fonts.fonts = [ pkgs.dejavu_fonts ];

    services.xserver.desktopManager.session = singleton
      { name = "gnome3";
        start = ''
          # Set GTK_DATA_PREFIX so that GTK+ can find the themes
          export GTK_DATA_PREFIX=${config.system.path}

          # find theme engines
          export GTK_PATH=${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0

          export XDG_MENU_PREFIX=gnome

          # Don't let epiphany depend upon gnome-shell
          # Don't let gnome-session depend upon vino (for .desktop autostart condition)
          # Override default mimeapps
          export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${gnome3.gnome_shell}/share/gsettings-schemas/${gnome3.gnome_shell.name}:${gnome3.vino}/share/gsettings-schemas/${gnome3.vino.name}:${mimeAppsList}/share

          # Let gnome-control-center find gnome-shell search providers
          export GNOME_SEARCH_PROVIDERS_DIR=${config.system.path}/share/gnome-shell/search-providers/

          # Let nautilus find extensions
          export NAUTILUS_EXTENSION_DIR=${config.system.path}/lib/nautilus/extensions-3.0/

          # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
          ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update

          ${gnome3.gnome_session}/bin/gnome-session&
          waitPID=$!
        '';
      };

    environment.variables.GIO_EXTRA_MODULES = [ "${gnome3.dconf}/lib/gio/modules"
                                                "${gnome3.glib_networking}/lib/gio/modules"
                                                "${gnome3.gvfs}/lib/gio/modules" ];
    environment.systemPackages =
      [ pkgs.desktop_file_utils
        gnome3.glib_networking
        gnome3.gtk3 # for gtk-update-icon-cache
        pkgs.ibus
        pkgs.shared_mime_info # for update-mime-database
        gnome3.gvfs
        gnome3.dconf
        gnome3.gnome-backgrounds
        gnome3.gnome_control_center
        gnome3.gnome_icon_theme
        gnome3.gnome-menus
        gnome3.gnome_settings_daemon
        gnome3.gnome_shell
        gnome3.gnome_themes_standard
      ] ++ (removePackagesByName [
        gnome3.baobab
        gnome3.empathy
        gnome3.eog
        gnome3.epiphany
        gnome3.evince
        gnome3.gucharmap
        gnome3.nautilus
        gnome3.totem
        gnome3.vino
        gnome3.yelp
        gnome3.gnome-calculator
        gnome3.gnome-contacts
        gnome3.gnome-font-viewer
        gnome3.gnome-screenshot
        gnome3.gnome-shell-extensions
        gnome3.gnome-system-log
        gnome3.gnome-system-monitor
        gnome3.gnome_terminal
        gnome3.gnome-user-docs

        gnome3.bijiben
        gnome3.evolution
        gnome3.file-roller
        gnome3.gedit
        gnome3.gnome-clocks
        gnome3.gnome-music
        gnome3.gnome-tweak-tool
        gnome3.gnome-photos
        gnome3.nautilus-sendto
      ] config.environment.gnome3.excludePackages);

    # Needed for themes and backgrounds
    environment.pathsToLink = [ "/share" ];

  };


}
