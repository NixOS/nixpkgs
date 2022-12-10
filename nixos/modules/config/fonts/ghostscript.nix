{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    fonts = {

      enableGhostscriptFonts = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to add the fonts provided by Ghostscript (such as
          various URW fonts and the “Base-14” Postscript fonts) to the
          list of system fonts, making them available to X11
          applications.
        '';
      };

    };

  };


  config = mkIf config.fonts.enableGhostscriptFonts {

    fonts.fonts = [ "${pkgs.ghostscript}/share/ghostscript/fonts" ];

  };

}
