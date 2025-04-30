{
  config,
  lib,
  pkgs,
  ...
}:
let
  aggregatedLocales =
    builtins.map
      (l: (lib.replaceStrings [ "utf8" "utf-8" "UTF8" ] [ "UTF-8" "UTF-8" "UTF-8" ] l) + "/UTF-8")
      (
        [ config.i18n.defaultLocale ]
        ++ config.i18n.extraLocales
        ++ (lib.attrValues (lib.filterAttrs (n: v: n != "LANGUAGE") config.i18n.extraLocaleSettings))
      );
in
{
  ###### interface

  options = {

    i18n = {
      glibcLocales = lib.mkOption {
        type = lib.types.path;
        default = pkgs.glibcLocales.override {
          allLocales = lib.any (x: x == "all") config.i18n.supportedLocales;
          locales = config.i18n.supportedLocales;
        };
        defaultText = lib.literalExpression ''
          pkgs.glibcLocales.override {
            allLocales = lib.any (x: x == "all") config.i18n.supportedLocales;
            locales = config.i18n.supportedLocales;
          }
        '';
        example = lib.literalExpression "pkgs.glibcLocales";
        description = ''
          Customized pkg.glibcLocales package.

          Changing this option can disable handling of i18n.defaultLocale
          and supportedLocale.
        '';
      };

      defaultLocale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        example = "nl_NL.UTF-8";
        description = ''
          The default locale.  It determines the language for program
          messages, the format for dates and times, sort order, and so on.
          It also determines the character set, such as UTF-8.
        '';
      };

      extraLocales = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "nl_NL.UTF-8" ];
        description = ''
          Additional locales that the system should support, besides the ones
          configured with {option}`i18n.defaultLocale` and
          {option}`i18n.extraLocaleSettings`.
        '';
      };

      extraLocaleSettings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          LC_MESSAGES = "en_US.UTF-8";
          LC_TIME = "de_DE.UTF-8";
        };
        description = ''
          A set of additional system-wide locale settings other than
          `LANG` which can be configured with
          {option}`i18n.defaultLocale`.
        '';
      };

      supportedLocales = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        visible = false;
        default = lib.unique (
          [
            "C.UTF-8/UTF-8"
            "en_US.UTF-8/UTF-8"
          ]
          ++ aggregatedLocales
        );
        example = [
          "en_US.UTF-8/UTF-8"
          "nl_NL.UTF-8/UTF-8"
          "nl_NL/ISO-8859-1"
        ];
        description = ''
          List of locales that the system should support.  The value
          `"all"` means that all locales supported by
          Glibc will be installed.  A full list of supported locales
          can be found at <https://sourceware.org/git/?p=glibc.git;a=blob;f=localedata/SUPPORTED>.
        '';
      };

    };

  };

  ###### implementation

  config = {
    warnings =
      lib.optional ((lib.subtractLists config.i18n.supportedLocales aggregatedLocales) != [ ])
        ''
          `i18n.supportedLocales` is deprecated in favor of `i18n.extraLocales`,
          and it seems you are using `i18n.supportedLocales` and forgot to
          include some locales specified in `i18n.defaultLocale`,
          `i18n.extraLocales` or `i18n.extraLocaleSettings`.

          If you're trying to install additional locales not specified in
          `i18n.defaultLocale` or `i18n.extraLocaleSettings`, consider adding
          only those locales to `i18n.extraLocales`.
        '';

    environment.systemPackages =
      # We increase the priority a little, so that plain glibc in systemPackages can't win.
      lib.optional (config.i18n.supportedLocales != [ ]) (lib.setPrio (-1) config.i18n.glibcLocales);

    environment.sessionVariables = {
      LANG = config.i18n.defaultLocale;
      LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
    } // config.i18n.extraLocaleSettings;

    systemd.globalEnvironment = lib.mkIf (config.i18n.supportedLocales != [ ]) {
      LOCALE_ARCHIVE = "${config.i18n.glibcLocales}/lib/locale/locale-archive";
    };

    # ‘/etc/locale.conf’ is used by systemd.
    environment.etc."locale.conf".source = pkgs.writeText "locale.conf" ''
      LANG=${config.i18n.defaultLocale}
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (n: v: "${n}=${v}") config.i18n.extraLocaleSettings
      )}
    '';

  };
}
