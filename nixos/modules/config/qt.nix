{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.qt;

  toQtIni = generators.toINI {
    mkKeyValue = key: value:
      let
        value' =
          if isBool value then (if value then "true" else "false")
          else toString value;
      in
        "${key}=${value'}";
  };

  general =
    optionalAttrs (cfg.font != null)
      {
        font = cfg.font.name;
        menuFont = cfg.font.name;
        toolBarFont = cfg.font.name;
      }
    //
    optionalAttrs (cfg.style != null)
      { widgetStyle = cfg.style.name; };
  icons =
    optionalAttrs (cfg.iconTheme != null)
      { Theme = cfg.iconTheme.name; };

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

  platforms = {
    gtk2 = rec {
      description = ''
        <varlistentry>
          <term><literal>gtk2</literal></term>
          <listitem><para>Use GTK2 theme with
            <link xlink:href="https://github.com/qt/qtstyleplugins">qtstyleplugins</link>
          </para></listitem>
        </varlistentry>
      '';
      styles = [ "cleanlooks" "gtk2" "cde" "motif" "plastique" ];

      assertions = [
        {
          assertion = cfg.style != null && any (name: name == cfg.style.name) styles;
          message = "`qt5.style.name` is not one of [ ${toString styles} ].";
        }
        {
          assertion = cfg.font == null && cfg.iconTheme == null;
          message = "`qt.font` and `qt.iconTheme` are only supported by kde platform.";
        }
      ];
      environment.variables.QT_QPA_PLATFORMTHEME = "gtk2";
      environment.variables.QT_STYLE_OVERRIDE = cfg.style.name;
      environment.systemPackages = [ pkgs.libsForQt5.qtstyleplugins ];
    };
    qgnomeplatform = {
      description = ''
        <varlistentry>
          <term><literal>qgnomeplatform</literal></term>
          <listitem><para>Use GNOME theme with
            <link xlink:href="https://github.com/FedoraQt/QGnomePlatform">qgnomeplatform</link>
          </para></listitem>
        </varlistentry>
      '';

      assertions = [
        {
          assertion = cfg.font == null && cfg.iconTheme == null;
          message = "`qt.font` and `qt.iconTheme` are only supported by kde platform.";
        }
      ];
      environment.variables.QT_QPA_PLATFORMTHEME = "qgnomeplatform";
      # TODO: make this optional once https://github.com/NixOS/nixpkgs/issues/54150 is fixed
      # qgnomeplatform reads theme and other settings from dconf db
      environment.variables.QT_STYLE_OVERRIDE = cfg.style.name;
      environment.systemPackages = [ pkgs.qgnomeplatform ];
    };
    gtk3 = {
      description = ''
        <varlistentry>
          <term><literal>gtk3</literal></term>
          <listitem><para>Use GNOME theme with
            <link xlink:href="https://code.qt.io/cgit/qt/qtbase.git/tree/src/plugins/platformthemes/gtk3">gtk3</link>
          </para></listitem>
        </varlistentry>
      '';

      assertions = [
        {
          assertion = cfg.style != null;
          message = "`qt5.platformTheme` gtk3 requires `qt5.style` to be set.";
        }
        {
          assertion = cfg.font == null && cfg.iconTheme == null;
          message = "`qt.font` and `qt.iconTheme` are only supported by kde platform.";
        }
      ];
      environment.variables.QT_QPA_PLATFORMTHEME = "gtk3";
      environment.variables.QT_STYLE_OVERRIDE = cfg.style.name;
    };
    kde = {
      description = ''
        <varlistentry>
          <term><literal>kde</literal></term>
          <listitem><para>Use Qt theme with
            <link xlink:href="https://code.qt.io/cgit/qt/qtbase.git/tree/src/platformsupport/themes/genericunix">qkdetheme</link>
          </para></listitem>
        </varlistentry>
      '';

      environment.variables.XDG_CURRENT_DESKTOP = mkForce "KDE";
      environment.variables.KDE_SESSION_VERSION = "5";
      environment.etc."xdg/kdeglobals".text =
        toQtIni {
          General = general;
          Icons = icons;
        };
    };
  };
in

{

  imports = [
    (mkRenamedOptionModule [ "qt5" "style" ] [ "qt" "style" ])
    (mkRenamedOptionModule [ "qt5" "enable" ] [ "qt" "enable" ])
    (mkRenamedOptionModule [ "qt5" "platformTheme" ] [ "qt" "platformTheme" ])
    (mkRenamedOptionModule [ "qt5" "font" ] [ "qt" "font" ])
    (mkRenamedOptionModule [ "qt5" "iconTheme" ] [ "qt" "iconTheme" ])
  ];

  options = {
    qt = {

      enable = mkEnableOption "Qt theming configuration";

      platformTheme = mkOption {
        type = types.enum (attrNames platforms);
        example = head (attrNames platforms);
        description = ''
          Selects the platform theme to use for Qt applications.</para>
          <para>The options are
          <variablelist>
            ${concatStrings (mapAttrsToList (name: value: value.description) platforms)}
          </variablelist>
        '';
      };

      font = mkOption {
        type = types.nullOr fontType;
        default = null;
        example = literalExample ''
          {
            name = "Noto Sans,10,-1,5,50,0,0,0,0,0,Regular";
            package = pkgs.noto-fonts;
          }
        '';
        description = ''
          The font to use in Qt applications.
        '';
      };

      iconTheme = mkOption {
        type = types.nullOr themeType;
        default = null;
        example = literalExample ''
          {
            name = "breeze";
            package = pkgs.breeze-icons;
          }
        '';
        description = "The icon theme to use.";
      };

      style = mkOption {
        type = types.nullOr themeType;
        default = null;
        example = literalExample ''
          {
            name = "Breeze";
            package = pkgs.breeze-qt5;
          };
        '';
        description = "The Qt style to use.";
      };

    };
  };

  config = mkIf cfg.enable {

    assertions = attrByPath [ cfg.platformTheme "assertions" ] [] platforms;

    environment.variables = attrByPath [ cfg.platformTheme "environment" "variables" ] {} platforms;

    environment.etc = attrByPath [ cfg.platformTheme "environment" "etc" ] {} platforms;

    environment.systemPackages = attrByPath [ cfg.platformTheme "environment" "systemPackages" ] [] platforms
      ++ optionalPackage cfg.font
      ++ optionalPackage cfg.style
      ++ optionalPackage cfg.iconTheme;

  };

  meta.maintainers = with maintainers; [ worldofpeace gnidorah ];
}
