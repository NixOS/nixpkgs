{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

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
      };
    };
  };
in

###### implementation

{
  require = [
    options
  ];
}
