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
        description = ''
          Selects the platform theme to use for Qt5 applications.</para>
          <para>The options are
          <variablelist>
            <varlistentry>
              <term><literal>gtk</literal></term>
              <listitem><para>Use GTK theme with
                <link xlink:href="https://github.com/qt/qtstyleplugins">qtstyleplugins</link>
              </para></listitem>
            </varlistentry>
            <varlistentry>
              <term><literal>gnome</literal></term>
              <listitem><para>Use GNOME theme with
                <link xlink:href="https://github.com/FedoraQt/QGnomePlatform">qgnomeplatform</link>
              </para></listitem>
            </varlistentry>
            <varlistentry>
              <term><literal>lxqt</literal></term>
              <listitem><para>Use LXQt style set using the
                <link xlink:href="https://github.com/lxqt/lxqt-config">lxqt-config-appearance</link>
                application.
              </para></listitem>
            </varlistentry>
            <varlistentry>
              <term><literal>qt5ct</literal></term>
              <listitem><para>Use Qt style set using the
                <link xlink:href="https://sourceforge.net/projects/qt5ct/">qt5ct</link>
                application.
              </para></listitem>
            </varlistentry>
            <varlistentry>
              <term><literal>kde</literal></term>
              <listitem><para>Use Qt settings from Plasma.</para></listitem>
            </varlistentry>
          </variablelist>
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
        description = ''
          Selects the style to use for Qt5 applications.</para>
          <para>The options are
          <variablelist>
            <varlistentry>
              <term><literal>adwaita</literal></term>
              <term><literal>adwaita-dark</literal></term>
              <listitem><para>Use Adwaita Qt style with
                <link xlink:href="https://github.com/FedoraQt/adwaita-qt">adwaita</link>
              </para></listitem>
            </varlistentry>
            <varlistentry>
              <term><literal>cleanlooks</literal></term>
              <term><literal>gtk2</literal></term>
              <term><literal>motif</literal></term>
              <term><literal>plastique</literal></term>
              <listitem><para>Use styles from
                <link xlink:href="https://github.com/qt/qtstyleplugins">qtstyleplugins</link>
              </para></listitem>
            </varlistentry>
          </variablelist>
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
