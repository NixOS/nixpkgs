{ config, lib, pkgs, ... }:

with lib;

{
<<<<<<< HEAD
  options = {
    fonts.enableGhostscriptFonts = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to add the fonts provided by Ghostscript (such as
        various URW fonts and the “Base-14” Postscript fonts) to the
        list of system fonts, making them available to X11
        applications.
      '';
=======

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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

  };

<<<<<<< HEAD
  config = mkIf config.fonts.enableGhostscriptFonts {
    fonts.packages = [ "${pkgs.ghostscript}/share/ghostscript/fonts" ];
  };
=======

  config = mkIf config.fonts.enableGhostscriptFonts {

    fonts.fonts = [ "${pkgs.ghostscript}/share/ghostscript/fonts" ];

  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
