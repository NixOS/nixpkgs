{ config, pkgs, ... }:

with pkgs.lib;

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
        default = "en_US.UTF-8";
        example = "nl_NL.UTF-8";
        description = "
          The default locale.  It determines the language for program
          messages, the format for dates and times, sort order, and so on.
          It also determines the character set, such as UTF-8.
        ";
      };

      supportedLocales = mkOption {
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
        default = "lat9w-16";
        example = "LatArCyrHeb-16";
        description = "
          The font used for the virtual consoles.  Leave empty to use
          whatever the <command>setfont</command> program considers the
          default font.
        ";
      };

      consoleKeyMap = mkOption {
        default = "us";
        example = "fr";
        description = "
          The keyboard mapping table for the virtual consoles.
        ";
        type = types.str;
      };

    };

  };


  ###### implementation

  config = {

    environment.systemPackages = [ glibcLocales ];

    environment.variables.LANG = config.i18n.defaultLocale;

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
