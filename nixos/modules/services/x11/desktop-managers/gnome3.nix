{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.gnome3;

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
      inode/directory=nautilus.desktop;org.gnome.Nautilus.desktop
    '';
  };

  nixos-gsettings-desktop-schemas = pkgs.runCommand "nixos-gsettings-desktop-schemas" {}
    ''
     mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas
     cp -rf ${pkgs.gnome3.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas*/glib-2.0/schemas/*.xml $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

     ${concatMapStrings (pkg: "cp -rf ${pkg}/share/gsettings-schemas/*/glib-2.0/schemas/*.xml $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas\n") cfg.extraGSettingsOverridePackages}

     chmod -R a+w $out/share/gsettings-schemas/nixos-gsettings-overrides
     cat - > $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/nixos-defaults.gschema.override <<- EOF
       [org.gnome.desktop.background]
       picture-uri='${pkgs.nixos-artwork.wallpapers.gnome-dark}/share/artwork/gnome/Gnome_Dark.png'

       [org.gnome.desktop.screensaver]
       picture-uri='${pkgs.nixos-artwork.wallpapers.gnome-dark}/share/artwork/gnome/Gnome_Dark.png'

       ${cfg.extraGSettingsOverrides}
     EOF

     ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
    '';

in {

  options = {

    services.xserver.desktopManager.gnome3 = {
      enable = mkOption {
        default = false;
        description = "Enable Gnome 3 desktop manager.";
      };

      sessionPath = mkOption {
        default = [];
        example = literalExample "[ pkgs.gnome3.gpaste ]";
        description = "Additional list of packages to be added to the session search path.
                       Useful for gnome shell extensions or gsettings-conditionated autostart.";
        apply = list: list ++ [ pkgs.gnome3.gnome-shell pkgs.gnome3.gnome-shell-extensions ];
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

    environment.gnome3.excludePackages = mkOption {
      default = [];
      example = literalExample "[ pkgs.gnome3.totem ]";
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
    services.dleyna-renderer.enable = mkDefault true;
    services.dleyna-server.enable = mkDefault true;
    services.gnome3.at-spi2-core.enable = true;
    services.gnome3.evolution-data-server.enable = true;
    services.gnome3.gnome-disks.enable = mkDefault true;
    services.gnome3.gnome-documents.enable = mkDefault true;
    services.gnome3.gnome-keyring.enable = true;
    services.gnome3.gnome-online-accounts.enable = mkDefault true;
    services.gnome3.gnome-terminal-server.enable = mkDefault true;
    services.gnome3.gnome-user-share.enable = mkDefault true;
    services.gnome3.gvfs.enable = true;
    services.gnome3.seahorse.enable = mkDefault true;
    services.gnome3.sushi.enable = mkDefault true;
    services.gnome3.tracker.enable = mkDefault true;
    services.gnome3.tracker-miners.enable = mkDefault true;
    hardware.pulseaudio.enable = mkDefault true;
    services.telepathy.enable = mkDefault true;
    networking.networkmanager.enable = mkDefault true;
    services.upower.enable = config.powerManagement.enable;
    services.dbus.packages = mkIf config.services.printing.enable [ pkgs.system-config-printer ];
    services.colord.enable = mkDefault true;
    services.packagekit.enable = mkDefault true;
    hardware.bluetooth.enable = mkDefault true;
    services.xserver.libinput.enable = mkDefault true; # for controlling touchpad settings via gnome control center
    services.udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];
    systemd.packages = [ pkgs.gnome3.vino ];

    # If gnome3 is installed, build vim for gtk3 too.
    nixpkgs.config.vim.gui = "gtk3";

    fonts.fonts = [ pkgs.dejavu_fonts pkgs.cantarell-fonts ];

    services.xserver.desktopManager.session = singleton
      { name = "gnome3";
        bgSupport = true;
        start = ''
          # Set GTK_DATA_PREFIX so that GTK+ can find the themes
          export GTK_DATA_PREFIX=${config.system.path}

          # find theme engines
          export GTK_PATH=${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0

          export XDG_MENU_PREFIX=gnome-

          ${concatMapStrings (p: ''
            if [ -d "${p}/share/gsettings-schemas/${p.name}" ]; then
              export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${p}/share/gsettings-schemas/${p.name}
            fi

            if [ -d "${p}/lib/girepository-1.0" ]; then
              export GI_TYPELIB_PATH=$GI_TYPELIB_PATH''${GI_TYPELIB_PATH:+:}${p}/lib/girepository-1.0
              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${p}/lib
            fi
          '') cfg.sessionPath}

          # Override default mimeapps
          export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${mimeAppsList}/share

          # Override gsettings-desktop-schema
          export NIX_GSETTINGS_OVERRIDES_DIR=${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

          # Let nautilus find extensions
          export NAUTILUS_EXTENSION_DIR=${config.system.path}/lib/nautilus/extensions-3.0/

          # Find the mouse
          export XCURSOR_PATH=~/.icons:${config.system.path}/share/icons

          # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
          ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update

          ${pkgs.gnome3.gnome-session}/bin/gnome-session ${optionalString cfg.debug "--debug"} &
          waitPID=$!
        '';
      };

    services.xserver.updateDbusEnvironment = true;

    environment.variables.GIO_EXTRA_MODULES = [ "${lib.getLib pkgs.gnome3.dconf}/lib/gio/modules"
                                                "${pkgs.gnome3.glib-networking.out}/lib/gio/modules"
                                                "${pkgs.gnome3.gvfs}/lib/gio/modules" ];
    environment.systemPackages = pkgs.gnome3.corePackages ++ cfg.sessionPath
      ++ (removePackagesByName pkgs.gnome3.optionalPackages config.environment.gnome3.excludePackages);

    # Use the correct gnome3 packageSet
    networking.networkmanager.basePackages =
      { inherit (pkgs) networkmanager modemmanager wpa_supplicant;
        inherit (pkgs.gnome3) networkmanager-openvpn networkmanager-vpnc
                              networkmanager-openconnect networkmanager-fortisslvpn
                              networkmanager-iodine networkmanager-l2tp; };

    # Needed for themes and backgrounds
    environment.pathsToLink = [ "/share" ];

  };


}
