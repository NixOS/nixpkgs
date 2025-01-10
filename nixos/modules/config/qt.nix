{ config, lib, pkgs, ... }:

let
  cfg = config.qt;

  platformPackages = with pkgs; {
    gnome = [ qgnomeplatform qgnomeplatform-qt6 ];
    gtk2 = [ libsForQt5.qtstyleplugins qt6Packages.qt6gtk2 ];
    kde = [ libsForQt5.plasma-integration libsForQt5.systemsettings ];
    lxqt = [ lxqt.lxqt-qtplugin lxqt.lxqt-config ];
    qt5ct = [ libsForQt5.qt5ct qt6Packages.qt6ct ];
  };

  stylePackages = with pkgs; {
    bb10bright = [ libsForQt5.qtstyleplugins ];
    bb10dark = [ libsForQt5.qtstyleplugins ];
    cde = [ libsForQt5.qtstyleplugins ];
    cleanlooks = [ libsForQt5.qtstyleplugins ];
    gtk2 = [ libsForQt5.qtstyleplugins qt6Packages.qt6gtk2 ];
    motif = [ libsForQt5.qtstyleplugins ];
    plastique = [ libsForQt5.qtstyleplugins ];

    adwaita = [ adwaita-qt adwaita-qt6 ];
    adwaita-dark = [ adwaita-qt adwaita-qt6 ];
    adwaita-highcontrast = [ adwaita-qt adwaita-qt6 ];
    adwaita-highcontrastinverse = [ adwaita-qt adwaita-qt6 ];

    breeze = [ libsForQt5.breeze-qt5 ];

    kvantum = [ libsForQt5.qtstyleplugin-kvantum qt6Packages.qtstyleplugin-kvantum ];
  };
in
{
  meta.maintainers = with lib.maintainers; [ romildo thiagokokada ];

  imports = [
    (lib.mkRenamedOptionModule [ "qt5" "enable" ] [ "qt" "enable" ])
    (lib.mkRenamedOptionModule [ "qt5" "platformTheme" ] [ "qt" "platformTheme" ])
    (lib.mkRenamedOptionModule [ "qt5" "style" ] [ "qt" "style" ])
  ];

  options = {
    qt = {
      enable = lib.mkEnableOption "" // {
        description = ''
          Whether to enable Qt configuration, including theming.

          Enabling this option is necessary for Qt plugins to work in the
          installed profiles (e.g.: `nix-env -i` or `environment.systemPackages`).
        '';
      };

      platformTheme = lib.mkOption {
        type = with lib.types; nullOr (enum (lib.attrNames platformPackages));
        default = null;
        example = "gnome";
        relatedPackages = [
          "qgnomeplatform"
          "qgnomeplatform-qt6"
          [ "libsForQt5" "plasma-integration" ]
          [ "libsForQt5" "qt5ct" ]
          [ "libsForQt5" "qtstyleplugins" ]
          [ "libsForQt5" "systemsettings" ]
          [ "lxqt" "lxqt-config" ]
          [ "lxqt" "lxqt-qtplugin" ]
          [ "qt6Packages" "qt6ct" ]
          [ "qt6Packages" "qt6gtk2" ]
        ];
        description = ''
          Selects the platform theme to use for Qt applications.

          The options are
          - `gnome`: Use GNOME theme with [qgnomeplatform](https://github.com/FedoraQt/QGnomePlatform)
          - `gtk2`: Use GTK theme with [qtstyleplugins](https://github.com/qt/qtstyleplugins)
          - `kde`: Use Qt settings from Plasma.
          - `lxqt`: Use LXQt style set using the [lxqt-config-appearance](https://github.com/lxqt/lxqt-config)
             application.
          - `qt5ct`: Use Qt style set using the [qt5ct](https://sourceforge.net/projects/qt5ct/)
             and [qt6ct](https://github.com/trialuser02/qt6ct) applications.
        '';
      };

      style = lib.mkOption {
        type = with lib.types; nullOr (enum (lib.attrNames stylePackages));
        default = null;
        example = "adwaita";
        relatedPackages = [
          "adwaita-qt"
          "adwaita-qt6"
          [ "libsForQt5" "breeze-qt5" ]
          [ "libsForQt5" "qtstyleplugin-kvantum" ]
          [ "libsForQt5" "qtstyleplugins" ]
          [ "qt6Packages" "qt6gtk2" ]
          [ "qt6Packages" "qtstyleplugin-kvantum" ]
        ];
        description = ''
          Selects the style to use for Qt applications.

          The options are
          - `adwaita`, `adwaita-dark`, `adwaita-highcontrast`, `adawaita-highcontrastinverse`:
            Use Adwaita Qt style with
            [adwaita](https://github.com/FedoraQt/adwaita-qt)
          - `breeze`: Use the Breeze style from
            [breeze](https://github.com/KDE/breeze)
          - `bb10bright`, `bb10dark`, `cleanlooks`, `gtk2`, `motif`, `plastique`:
            Use styles from
            [qtstyleplugins](https://github.com/qt/qtstyleplugins)
          - `kvantum`: Use styles from
            [kvantum](https://github.com/tsujan/Kvantum)
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      let
        gnomeStyles = [
          "adwaita"
          "adwaita-dark"
          "adwaita-highcontrast"
          "adwaita-highcontrastinverse"
          "breeze"
        ];
      in
      [
        {
          assertion = cfg.platformTheme == "gnome" -> (builtins.elem cfg.style gnomeStyles);
          message = ''
            `qt.platformTheme` "gnome" must have `qt.style` set to a theme that supports both Qt and Gtk,
            for example: ${lib.concatStringsSep ", " gnomeStyles}.
          '';
        }
      ];

    environment.variables = {
      QT_QPA_PLATFORMTHEME = lib.mkIf (cfg.platformTheme != null) cfg.platformTheme;
      QT_STYLE_OVERRIDE = lib.mkIf (cfg.style != null) cfg.style;
    };

    environment.profileRelativeSessionVariables =
      let
        qtVersions = with pkgs; [ qt5 qt6 ];
      in
      {
        QT_PLUGIN_PATH = map (qt: "/${qt.qtbase.qtPluginPrefix}") qtVersions;
        QML2_IMPORT_PATH = map (qt: "/${qt.qtbase.qtQmlPrefix}") qtVersions;
      };

    environment.systemPackages =
      lib.optionals (cfg.platformTheme != null) (platformPackages.${cfg.platformTheme})
      ++ lib.optionals (cfg.style != null) (stylePackages.${cfg.style});
  };
}
