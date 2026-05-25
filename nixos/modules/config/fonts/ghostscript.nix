{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    fonts.enableGhostscriptFonts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to add the fonts provided by Ghostscript (such as
        various URW fonts and the “Base-14” Postscript fonts) to the
        list of system fonts, making them available to X11
        applications.
      '';
    };

  };

  config = lib.mkIf config.fonts.enableGhostscriptFonts {
    fonts.packages = [ pkgs.ghostscript.fonts ];
  };
}
