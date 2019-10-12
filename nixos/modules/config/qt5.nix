{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.qt5;

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

      environment.variables.QT_QPA_PLATFORMTHEME = "qgnomeplatform";
      # TODO: make this optional once https://github.com/NixOS/nixpkgs/issues/54150 is fixed
      # qgnomeplatform reads theme and other settings from dconf db
      environment.variables.QT_STYLE_OVERRIDE = cfg.style.name;
      environment.variables.XDG_DATA_DIRS = [ "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}" ];
      environment.systemPackages = [ pkgs.qgnomeplatform ];
    };
  };
in

{

  options = {
    qt5 = {

      enable = mkEnableOption "Qt5 theming configuration";

      platformTheme = mkOption {
        type = types.enum (attrNames platforms);
        example = head (attrNames platforms);
        description = ''
          Selects the platform theme to use for Qt5 applications.</para>
          <para>The options are
          <variablelist>
            ${concatStrings (mapAttrsToList (name: value: value.description) platforms)}
          </variablelist>
        '';
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

    environment.systemPackages = attrByPath [ cfg.platformTheme "environment" "systemPackages" ] [] platforms
      ++ optionalPackage cfg.style;

  };

  meta.maintainers = with maintainers; [ worldofpeace gnidorah ];
}
