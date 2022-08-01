{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.qt5;

  isQGnome = cfg.platformTheme == "gnome" && builtins.elem cfg.style ["adwaita" "adwaita-dark"];
  isQtStyle = cfg.platformTheme == "gtk2" && !(builtins.elem cfg.style ["adwaita" "adwaita-dark"]);
  isQt5ct = cfg.platformTheme == "qt5ct";
  isLxqt = cfg.platformTheme == "lxqt";
  isKde = cfg.platformTheme == "kde";

  packages = if isQGnome then [ pkgs.qgnomeplatform pkgs.adwaita-qt ]
    else if isQtStyle then [ pkgs.libsForQt5.qtstyleplugins ]
    else if isQt5ct then [ pkgs.libsForQt5.qt5ct ]
    else if isLxqt then [ pkgs.lxqt.lxqt-qtplugin pkgs.lxqt.lxqt-config ]
    else if isKde then [ pkgs.libsForQt5.plasma-integration pkgs.libsForQt5.systemsettings ]
    else throw "`qt5.platformTheme` ${cfg.platformTheme} and `qt5.style` ${cfg.style} are not compatible.";

in

{
  meta.maintainers = [ maintainers.romildo ];

  options = {
    qt5 = {

      enable = mkEnableOption "Qt5 theming configuration";

      platformTheme = mkOption {
        type = types.enum [
          "gtk2"
          "gnome"
          "lxqt"
          "qt5ct"
          "kde"
        ];
        example = "gnome";
        relatedPackages = [
          "qgnomeplatform"
          ["libsForQt5" "qtstyleplugins"]
          ["libsForQt5" "qt5ct"]
          ["lxqt" "lxqt-qtplugin"]
          ["libsForQt5" "plasma-integration"]
        ];
        description = lib.mdDoc ''
          Selects the platform theme to use for Qt5 applications.

          The options are
          - `gtk`: Use GTK theme with [qtstyleplugins](https://github.com/qt/qtstyleplugins)
          - `gnome`: Use GNOME theme with [qgnomeplatform](https://github.com/FedoraQt/QGnomePlatform)
          - `lxqt`: Use LXQt style set using the [lxqt-config-appearance](https://github.com/lxqt/lxqt-config)
             application.
          - `qt5ct`: Use Qt style set using the [qt5ct](https://sourceforge.net/projects/qt5ct/)
             application.
          - `kde`: Use Qt settings from Plasma.
        '';
      };

      style = mkOption {
        type = types.enum [
          "adwaita"
          "adwaita-dark"
          "cleanlooks"
          "gtk2"
          "motif"
          "plastique"
        ];
        example = "adwaita";
        relatedPackages = [
          "adwaita-qt"
          ["libsForQt5" "qtstyleplugins"]
        ];
        description = lib.mdDoc ''
          Selects the style to use for Qt5 applications.

          The options are
          - `adwaita`, `adwaita-dark`: Use Adwaita Qt style with
            [adwaita](https://github.com/FedoraQt/adwaita-qt)
          - `cleanlooks`, `gtk2`, `motif`, `plastique`: Use styles from
            [qtstyleplugins](https://github.com/qt/qtstyleplugins)
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    environment.variables.QT_QPA_PLATFORMTHEME = cfg.platformTheme;

    environment.variables.QT_STYLE_OVERRIDE = mkIf (! (isQt5ct || isLxqt || isKde)) cfg.style;

    environment.systemPackages = packages;

  };
}
