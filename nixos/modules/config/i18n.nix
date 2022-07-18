{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {

    i18n = {
      glibcLocales = mkOption {
        type = types.path;
        default = pkgs.buildPackages.glibcLocales.override {
          allLocales = any (x: x == "all") config.i18n.supportedLocales;
          locales = config.i18n.supportedLocales;
        };
        defaultText = literalExpression ''
          pkgs.buildPackages.glibcLocales.override {
            allLocales = any (x: x == "all") config.i18n.supportedLocales;
            locales = config.i18n.supportedLocales;
          }
        '';
        example = literalExpression "pkgs.glibcLocales";
        description = ''
          Customized pkg.glibcLocales package.

          Changing this option can disable handling of i18n.defaultLocale
          and supportedLocale.
        '';
      };

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

      extraLocaleSettings = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = { LC_MESSAGES = "en_US.UTF-8"; LC_TIME = "de_DE.UTF-8"; };
        description = ''
          A set of additional system-wide locale settings other than
          <literal>LANG</literal> which can be configured with
          <option>i18n.defaultLocale</option>.
        '';
      };

      supportedLocales = mkOption {
        type = types.listOf types.str;
        default = unique
          (builtins.map (l: (replaceStrings [ "utf8" "utf-8" "UTF8" ] [ "UTF-8" "UTF-8" "UTF-8" ] l) + "/UTF-8") (
            [
              "C.UTF-8"
              config.i18n.defaultLocale
            ] ++ (attrValues (filterAttrs (n: v: n != "LANGUAGE") config.i18n.extraLocaleSettings))
          ));
        defaultText = literalExpression ''
          unique
            (builtins.map (l: (replaceStrings [ "utf8" "utf-8" "UTF8" ] [ "UTF-8" "UTF-8" "UTF-8" ] l) + "/UTF-8") (
              [
                "C.UTF-8"
                config.i18n.defaultLocale
              ] ++ (attrValues (filterAttrs (n: v: n != "LANGUAGE") config.i18n.extraLocaleSettings))
            ))
        '';
        example = ["en_US.UTF-8/UTF-8" "nl_NL.UTF-8/UTF-8" "nl_NL/ISO-8859-1"];
        description = ''
          List of locales that the system should support.  The value
          <literal>"all"</literal> means that all locales supported by
          Glibc will be installed.  A full list of supported locales
          can be found at <link
          xlink:href="https://sourceware.org/git/?p=glibc.git;a=blob;f=localedata/SUPPORTED"/>.
        '';
      };

    };

  };


  ###### implementation

  config = {

    environment.systemPackages =
      # We increase the priority a little, so that plain glibc in systemPackages can't win.
      optional (config.i18n.supportedLocales != []) (lib.setPrio (-1) config.i18n.glibcLocales);

    environment.sessionVariables =
      { LANG = config.i18n.defaultLocale;
        LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
      } // config.i18n.extraLocaleSettings;

    systemd.globalEnvironment = mkIf (config.i18n.supportedLocales != []) {
      LOCALE_ARCHIVE = "${config.i18n.glibcLocales}/lib/locale/locale-archive";
    };

    # ‘/etc/locale.conf’ is used by systemd.
    environment.etc."locale.conf".source = pkgs.writeText "locale.conf"
      ''
        LANG=${config.i18n.defaultLocale}
        ${concatStringsSep "\n" (mapAttrsToList (n: v: "${n}=${v}") config.i18n.extraLocaleSettings)}
      '';

  };
}
