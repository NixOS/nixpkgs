{ config, pkgs, ... }:

with pkgs.lib;

{

  options = {

    fonts = {

      enableGhostscriptFonts = mkOption {
        default = false;
        description = ''
          Whether to add the fonts provided by Ghostscript (such as
          various URW fonts and the “Base-14” Postscript fonts) to the
          list of system fonts, making them available to X11
          applications.
        '';
      };

    };

  };


  config = mkIf config.fonts.enableGhostscriptFonts {

    fonts.extraFonts = [ "${pkgs.ghostscript}/share/ghostscript/fonts" ];

  };

}
