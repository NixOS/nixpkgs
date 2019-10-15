{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.qt5;

  isQGnome = cfg.platformTheme == "gnome" && cfg.style == "adwaita";
  isQtStyle = cfg.platformTheme == "gtk2" && cfg.style != "adwaita";

  packages = if isQGnome then [ pkgs.qgnomeplatform pkgs.adwaita-qt ]
    else if isQtStyle then [ pkgs.qtstyleplugins ]
    else throw "`qt5.platformTheme` ${cfg.platformTheme} and `qt5.style` ${cfg.style} are not compatible.";

in

{

  options = {
    qt5 = {

      enable = mkEnableOption "Qt5 theming configuration";

      platformTheme = mkOption {
        type = types.enum [
          "gtk2"
          "gnome"
        ];
        example = "gnome";
        relatedPackages = [
          "qgnomeplatform"
          ["libsForQt5" "qtstyleplugins"]
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
          </variablelist>
        '';
      };

      style = mkOption {
        type = types.enum [
          "adwaita"
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

    environment.variables.QT_STYLE_OVERRIDE = cfg.style;

    environment.systemPackages = packages;

  };
}
