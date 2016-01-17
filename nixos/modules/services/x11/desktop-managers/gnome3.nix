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
      inode/directory=nautilus.desktop;org.gnome.Nautilus.desktop
    '';
  };

  nixos-gsettings-desktop-schemas = pkgs.stdenv.mkDerivation {
    name = "nixos-gsettings-desktop-schemas";
    buildInputs = [ pkgs.nixos-artwork ];
    buildCommand = ''
     mkdir -p $out/share/nixos-gsettings-schemas/nixos-gsettings-desktop-schemas
     cp -rf ${gnome3.gsettings_desktop_schemas}/share/gsettings-schemas/gsettings-desktop-schemas*/glib-2.0 $out/share/nixos-gsettings-schemas/nixos-gsettings-desktop-schemas/
     chmod -R a+w $out/share/nixos-gsettings-schemas/nixos-gsettings-desktop-schemas
     cat - > $out/share/nixos-gsettings-schemas/nixos-gsettings-desktop-schemas/glib-2.0/schemas/nixos-defaults.gschema.override <<- EOF
       [org.gnome.desktop.background]
       picture-uri='${pkgs.nixos-artwork}/share/artwork/gnome/Gnome_Dark.png'

       [org.gnome.desktop.screensaver]
       picture-uri='${pkgs.nixos-artwork}/share/artwork/gnome/Gnome_Dark.png'
     EOF
     ${pkgs.glib}/bin/glib-compile-schemas $out/share/nixos-gsettings-schemas/nixos-gsettings-desktop-schemas/glib-2.0/schemas/
    '';
  };

in {

  options = {

    services.xserver.desktopManager.gnome3.enable = mkOption {
      default = false;
      example = true;
      description = "Enable Gnome 3 desktop manager.";
    };

    services.xserver.desktopManager.gnome3.sessionPath = mkOption {
      default = [];
      example = literalExample "[ pkgs.gnome3.gpaste ]";
      description = "Additional list of packages to be added to the session search path.
                     Useful for gnome shell extensions or gsettings-conditionated autostart.";
      apply = list: list ++ [ gnome3.gnome_shell gnome3.gnome-shell-extensions ];
    };

    environment.gnome3.packageSet = mkOption {
      type = types.nullOr types.package;
      default = null;
      example = literalExample "pkgs.gnome3_16";
      description = "Which GNOME 3 package set to use.";
      apply = p: if p == null then pkgs.gnome3 else p;
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
    networking.networkmanager.enable = mkDefault true;
    services.upower.enable = config.powerManagement.enable;
    hardware.bluetooth.enable = mkDefault true;

    fonts.fonts = [ pkgs.dejavu_fonts pkgs.cantarell_fonts ];

    services.xserver.desktopManager.session = singleton
      { name = "gnome3";
        bgSupport = true;
        start = ''
          # Set GTK_DATA_PREFIX so that GTK+ can find the themes
          export GTK_DATA_PREFIX=${config.system.path}

          # find theme engines
          export GTK_PATH=${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0

          export XDG_MENU_PREFIX=gnome

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
          export XDG_DATA_DIRS=${nixos-gsettings-desktop-schemas}/share/nixos-gsettings-schemas/nixos-gsettings-desktop-schemas''${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS

          # Let nautilus find extensions
          export NAUTILUS_EXTENSION_DIR=${config.system.path}/lib/nautilus/extensions-3.0/

          # Find the mouse
          export XCURSOR_PATH=~/.icons:${config.system.path}/share/icons

          # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
          ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update

          ${gnome3.gnome_session}/bin/gnome-session&
          waitPID=$!
        '';
      };

    environment.variables.GIO_EXTRA_MODULES = [ "${gnome3.dconf}/lib/gio/modules"
                                                "${gnome3.glib_networking}/lib/gio/modules"
                                                "${gnome3.gvfs}/lib/gio/modules" ];
    environment.systemPackages = gnome3.corePackages ++ cfg.sessionPath
      ++ (removePackagesByName gnome3.optionalPackages config.environment.gnome3.excludePackages);

    # Use the correct gnome3 packageSet
    networking.networkmanager.basePackages =
      { inherit (pkgs) networkmanager modemmanager wpa_supplicant;
        inherit (gnome3) networkmanager_openvpn networkmanager_vpnc
                         networkmanager_openconnect networkmanager_pptp
                         networkmanager_l2tp; };

    # Needed for themes and backgrounds
    environment.pathsToLink = [ "/share" ];

  };


}
