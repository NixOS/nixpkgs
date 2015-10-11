{ config, lib, pkgs, ... }:

with lib;

let

  glibcLocales = pkgs.glibcLocales.override {
    allLocales = any (x: x == "all") config.i18n.supportedLocales;
    locales = config.i18n.supportedLocales;
  };

in

{
  ###### interface

  options = {

    i18n = {
      defaultLocale = mkOption {
        type = types.str;
        default = "en_US.UTF-8";
        example = "nl_NL.UTF-8";
        description = ''
          The default locale.  It determines the language for program
          messages, the format for dates and times, sort order, and so on.
          It also determines the character set, such as UTF-8.
        '';
      };

      supportedLocales = mkOption {
        type = types.listOf types.str;
        default = ["all"];
        example = ["en_US.UTF-8/UTF-8" "nl_NL.UTF-8/UTF-8" "nl_NL/ISO-8859-1"];
        description = ''
          List of locales that the system should support.  The value
          <literal>"all"</literal> means that all locales supported by
          Glibc will be installed.  A full list of supported locales
          can be found at <link
          xlink:href="http://sourceware.org/cgi-bin/cvsweb.cgi/libc/localedata/SUPPORTED?cvsroot=glibc"/>.
        '';
      };

      consoleFont = mkOption {
        type = types.str;
        default = "Lat2-Terminus16";
        example = "LatArCyrHeb-16";
        description = ''
          The font used for the virtual consoles.  Leave empty to use
          whatever the <command>setfont</command> program considers the
          default font.
        '';
      };

      consoleUseXkbConfig = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If set, configure the console keymap from the xserver keyboard
          settings.
        '';
      };

      consoleKeyMap = mkOption {
        type = mkOptionType {
          name = "string or path";
          check = t: (isString t || types.path.check t);
        };

        default = "us";
        example = "fr";
        description = ''
          The keyboard mapping table for the virtual consoles.
        '';
      };

      consoleColors = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [
          "002b36" "dc322f" "859900" "b58900"
          "268bd2" "d33682" "2aa198" "eee8d5"
          "002b36" "cb4b16" "586e75" "657b83"
          "839496" "6c71c4" "93a1a1" "fdf6e3"
        ];
        description = ''
          The 16 colors palette used by the virtual consoles.
          Leave empty to use the default colors.
          Colors must be in hexadecimal format and listed in
          order from color 0 to color 15.
        '';
      };

    };

  };


  ###### implementation

  config = {

    i18n.consoleKeyMap = with config.services.xserver;
      mkIf config.i18n.consoleUseXkbConfig
        (pkgs.runCommand "xkb-console-keymap" { preferLocalBuild = true; } ''
          '${pkgs.ckbcomp}/bin/ckbcomp' -model '${xkbModel}' -layout '${layout}' \
            -option '${xkbOptions}' -variant '${xkbVariant}' > "$out"
        '');

    environment.systemPackages =
      optional (config.i18n.supportedLocales != []) glibcLocales;

    environment.sessionVariables =
      { LANG = config.i18n.defaultLocale;
        LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
      };

    systemd.globalEnvironment = mkIf (config.i18n.supportedLocales != []) {
      LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
    };

    # ‘/etc/locale.conf’ is used by systemd.
    environment.etc = singleton
      { target = "locale.conf";
        source = pkgs.writeText "locale.conf"
          ''
            LANG=${config.i18n.defaultLocale}
          '';
      };

  };
}
