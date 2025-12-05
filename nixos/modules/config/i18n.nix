{
  config,
  lib,
  pkgs,
  ...
}:
let
  sanitizeUTF8Capitalization =
    lang: (lib.replaceStrings [ "utf8" "utf-8" "UTF8" ] [ "UTF-8" "UTF-8" "UTF-8" ] lang);
  aggregatedLocales =
    lib.optionals (config.i18n.defaultLocale != "C") [
      "${config.i18n.defaultLocale}/${config.i18n.defaultCharset}"
    ]
    ++ lib.pipe config.i18n.extraLocaleSettings [
      # See description of extraLocaleSettings for why is this ignored here.
      (x: lib.removeAttrs x [ "LANGUAGE" ])
      (lib.mapAttrs (n: v: (sanitizeUTF8Capitalization v)))
      # C locales are always installed
      (lib.filterAttrs (n: v: v != "C"))
      (lib.mapAttrsToList (LCRole: lang: lang + "/" + (config.i18n.localeCharsets.${LCRole} or "UTF-8")))
    ]
    ++ (builtins.map sanitizeUTF8Capitalization (
      lib.optionals (builtins.isList config.i18n.extraLocales) config.i18n.extraLocales
    ))
    ++ (lib.optional (builtins.isString config.i18n.extraLocales) config.i18n.extraLocales);
in
{
  ###### interface

  options = {

    i18n = {
      glibcLocales = lib.mkOption {
        type = lib.types.path;
        default = pkgs.glibcLocales.override {
          allLocales = lib.elem "all" config.i18n.supportedLocales;
          locales = config.i18n.supportedLocales;
        };
        defaultText = lib.literalExpression ''
          pkgs.glibcLocales.override {
            allLocales = lib.elem "all" config.i18n.supportedLocales;
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
          The default locale. It determines the language for program messages,
          the format for dates and times, sort order, and so on. Setting the
          default character set is done via {option}`i18n.defaultCharset`.
        '';
      };
      defaultCharset = lib.mkOption {
        type = lib.types.str;
        default = "UTF-8";
        example = "ISO-8859-8";
        description = ''
          The default locale character set.
        '';
      };

      extraLocales = lib.mkOption {
        type = lib.types.either (lib.types.listOf lib.types.str) (lib.types.enum [ "all" ]);
        default = [ ];
        example = [ "nl_NL.UTF-8/UTF-8" ];
        description = ''
          Additional locales that the system should support, besides the ones
          configured with {option}`i18n.defaultLocale` and
          {option}`i18n.extraLocaleSettings`.
          Set this to `"all"` to install all available locales.
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
          A set of additional system-wide locale settings other than `LANG`
          which can be configured with {option}`i18n.defaultLocale`. Note that
          the `/UTF-8` suffix used in {option}`i18n.extraLocales` indicates a
          character set, and it must not be added manually here. To use a
          non-`UTF-8` character set such as ISO-XXXX-8, the
          {option}`i18n.localeCharsets` can be used.

          Note that if the [`LANGUAGE`
          key](https://www.gnu.org/software/gettext/manual/html_node/The-LANGUAGE-variable.html)
          is used in this option, it is ignored when computing the locales
          required to be installed, because the possible values of this key are
          more diverse and flexible then the others.
        '';
      };
      localeCharsets = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          LC_MESSAGES = "ISO-8859-15";
          LC_TIME = "ISO-8859-1";
        };
        description = ''
          Per each {option}`i18n.extraLocaleSettings`, choose the character set
          to use for it. Essentially defaults to UTF-8 for all of them.

          Note that for a locale category that uses the `C` locale, setting a
          character set to it via this setting is ignored.
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
      lib.optional
        (
          !(
            (lib.subtractLists config.i18n.supportedLocales aggregatedLocales) == [ ]
            || lib.elem "all" config.i18n.supportedLocales
          )
        )
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
    }
    // config.i18n.extraLocaleSettings;

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
