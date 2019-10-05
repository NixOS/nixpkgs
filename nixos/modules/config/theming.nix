{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.theming;
  gcfg = config.theming.gtk;
  qcfg = config.theming.qt;
  theme = config.theming.theme;

  toGtk2Ini = key: value:
    let
      value' =
        if isBool value then (if value then "true" else "false")
        else if isString value then "\"${value}\""
        else toString value;
    in
      "${key} = ${value'}";
  toGtk3Ini = generators.toINI {
    mkKeyValue = key: value:
      let
        value' =
          if isBool value then (if value then "true" else "false")
          else toString value;
      in
        "${key}=${value'}";
  };
  toDconfIni = generators.toINI {
    mkKeyValue = key: value:
      let
        value' =
          if isBool value then (if value then "true" else "false")
          else toString value;
      in
        "${key}='${value'}'";
  };

  fontType = types.submodule {
    options = {
      package = mkOption {
        internal = true;
        type = types.nullOr types.package;
        default = null;
      };
      name = mkOption {
        internal = true;
        type = types.str;
      };
    };
  };
  themeType = types.submodule {
    options = {
      package = mkOption {
        internal = true;
        type = types.nullOr types.package;
        default = null;
      };
      name = mkOption {
        internal = true;
        type = types.str;
      };
    };
  };

  optionalPackage = opt:
    optional (opt != null && opt.package != null) opt.package;
in
{
  options = {
    theming = {
      gtk = {
        enable = mkEnableOption "Gtk3 theming configuration";

        font = mkOption {
          type = types.nullOr fontType;
          default = null;
          description = ''
            The font to use in GTK+ 3 applications.
          '';
        };

        iconTheme = mkOption {
          type = types.nullOr themeType;
          default = null;
          description = "The icon theme to use.";
        };

        theme = mkOption {
          type = types.nullOr themeType;
          default = null;
          description = "The GTK+3 theme to use.";
        };
      };

      qt = {
        enable = mkEnableOption "Qt5 theming configuration";

        font = mkOption {
          type = types.nullOr fontType;
          default = null;
          description = ''
            The font to use in Qt 5 applications.
          '';
        };

        iconTheme = mkOption {
          type = types.nullOr themeType;
          default = null;
          description = "The icon theme to use.";
        };

        theme = mkOption {
          type = types.nullOr themeType;
          default = null;
          description = "The Qt5 theme to use.";
        };

        scheme = mkOption {
          type = types.nullOr themeType;
          default = null;
          description = "The Qt5 color scheme to use.";
        };
      };

      theme = mkOption {
        type = types.nullOr (types.enum [
          "adwaita"
          "adwaitadark"
          "breeze"
          "breezedark"
        ]);
        default = null;
        description = ''
          Predefined themes that are defaults in Plasma and Gnome environments.
        '';
      };

    };
  };

  config = mkMerge [
    
    (mkIf gcfg.enable
      (let
        settings =
          optionalAttrs (gcfg.font != null)
            { gtk-font-name = gcfg.font.name; }
          //
          optionalAttrs (gcfg.theme != null)
            { gtk-theme-name = gcfg.theme.name; }
          //
          optionalAttrs (gcfg.iconTheme != null)
            { gtk-icon-theme-name = gcfg.iconTheme.name; };

        keyfile =
          optionalAttrs (gcfg.font != null)
            { font-name = gcfg.font.name; }
          //
          optionalAttrs (gcfg.theme != null)
            { gtk-theme = gcfg.theme.name; }  
          // 
          optionalAttrs (gcfg.iconTheme != null)
            { icon-theme = gcfg.iconTheme.name; };

      in {
        # Standard theme engines for Gtk2
        environment.systemPackages = [ pkgs.gtk2 ]
            ++ optionalPackage gcfg.font
            ++ optionalPackage gcfg.theme
            ++ optionalPackage gcfg.iconTheme;

        environment.etc."xdg/gtk-2.0/gtkrc".text =
          concatStringsSep "\n" (
            mapAttrsToList toGtk2Ini settings
          );

        environment.etc."xdg/gtk-3.0/settings.ini".text =
          toGtk3Ini { Settings = settings; };

        # disabled until https://github.com/NixOS/nixpkgs/issues/54150 is fixed
        # in case of XSettings daemon or Wayland environment
        programs.dconf.enable = mkDefault true;
        environment.etc."dconf/db/site.d/00_gtk_theme".text =
          toDconfIni { "org/gnome/desktop/interface" = keyfile; };
        #environment.etc."dconf/profile/user".text = ''
        #  user-db:user
        #  system-db:site
        #'';
        systemd.services.dconf-update = {
          description = "Updates system-db after site settings are changed";
          #wantedBy = [ "multi-user.target" ];
          restartTriggers = [ config.environment.etc."dconf/db/site.d/00_gtk_theme".source ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.gnome3.dconf}/bin/dconf update";
          };
        };
      })
    )

    (mkIf qcfg.enable
      (let
        general =
          optionalAttrs (qcfg.font != null)
            {
              font = qcfg.font.name;
              menuFont = qcfg.font.name;
              toolBarFont = qcfg.font.name;
            }
          //
          optionalAttrs (qcfg.scheme != null)
            { ColorScheme = qcfg.scheme.name; }
          //
          # for QKdeTheme
          optionalAttrs (qcfg.theme != null)
            { widgetStyle = qcfg.theme.name; };
        kde =
          optionalAttrs (qcfg.theme != null)
            { widgetStyle = qcfg.theme.name; };
        icons =
          optionalAttrs (qcfg.iconTheme != null)
            { Theme = qcfg.iconTheme.name; };

        qt =
          optionalAttrs (qcfg.font != null)
            { font = ''"${qcfg.font.name}"''; }
          //
          optionalAttrs (gcfg.theme != null)
            { style = "GTK+"; };
      in {
        # because QKdeTheme doesn't read ColorScheme key
        # and also requires environment variables to be set
        # XDG_CURRENT_DESKTOP=KDE KDE_SESSION_VERSION=5
        environment.systemPackages = [ pkgs.plasma-integration ]
            ++ optionalPackage qcfg.font
            ++ optionalPackage qcfg.theme
            ++ optionalPackage qcfg.iconTheme;

        environment.pathsToLink = [
          "/share/color-schemes"
        ];

        # Qt4
        environment.etc."xdg/Trolltech.conf".text =
          toGtk3Ini {
            Qt = qt;
          };

        # Qt5
        environment.etc."xdg/kdeglobals".text =
          toGtk3Ini {
            General = general;
            KDE = kde;
            Icons = icons;
          };

        environment.variables.QT_QPA_PLATFORMTHEME = "kde";
      })
    )

    (mkIf (theme == "adwaita") {
      theming = {
        gtk = {
          enable = true;
          font = {
            name = "Cantarell 11";
            package = pkgs.cantarell-fonts;
          };
          iconTheme = {
            name = "Adwaita";
            package = pkgs.gnome3.adwaita-icon-theme;
          };
          theme.name = "Adwaita";
        };
        qt = {
          enable = true;
          font = {
            name = "Cantarell,11,-1,5,50,0,0,0,0,0,Regular";
            package = pkgs.cantarell-fonts;
          };
          iconTheme = {
            name = "Adwaita";
            package = pkgs.gnome3.adwaita-icon-theme;
          };
          theme = {
            name = "Adwaita";
            package = pkgs.adwaita-qt;
          };
        };
      };
    })
    (mkIf (theme == "adwaitadark") {
      theming = {
        gtk = {
          enable = true;
          font = {
            name = "Cantarell 11";
            package = pkgs.cantarell-fonts;
          };
          iconTheme = {
            name = "Adwaita";
            package = pkgs.gnome3.adwaita-icon-theme;
          };
          theme.name = "Adwaita-dark";
        };
        qt = {
          enable = true;
          font = {
            name = "Cantarell,11,-1,5,50,0,0,0,0,0,Regular";
            package = pkgs.cantarell-fonts;
          };
          iconTheme = {
            name = "Adwaita";
            package = pkgs.gnome3.adwaita-icon-theme;
          };
          theme = {
            name = "adwaita-dark";
            package = pkgs.adwaita-qt;
          };
        };
      };
    })
    (mkIf (theme == "breeze") {
      theming = {
        gtk = { 
          enable = true;
          font.name = "Sans Serif Regular 10";
          iconTheme = {
            name = "breeze";
            package = pkgs.breeze-icons;
          };
          theme = {
            name = "Breeze";
            package = pkgs.breeze-gtk;
          };
        };
        qt = {
          enable = true;
          font.name = "Sans Serif,10,-1,5,50,0,0,0,0,0,Regular";
          iconTheme = {
            name = "breeze";
            package = pkgs.breeze-icons;
          };
          theme = {
            name = "Breeze";
            package = pkgs.breeze-qt5;
          };
        };
      };
    })
    (mkIf (theme == "breezedark") {
      theming = {
        gtk = { 
          enable = true;
          font.name = "Sans Serif Regular 10";
          iconTheme = {
            name = "breeze-dark";
            package = pkgs.breeze-icons;
          };
          theme = {
            name = "Breeze-Dark";
            package = pkgs.breeze-gtk;
          };
        };
        qt = {
          enable = true;
          font.name = "Sans Serif,10,-1,5,50,0,0,0,0,0,Regular";
          iconTheme = {
            name = "breeze-dark";
            package = pkgs.breeze-icons;
          };
          theme = {
            name = "Breeze";
            package = pkgs.breeze-qt5;
          };
          scheme.name = "BreezeDark";
        };
      };
    })

  ];

  meta.maintainers = [ maintainers.gnidorah ];
}
