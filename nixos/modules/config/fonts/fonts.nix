{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    fonts = {

      # TODO: find another name for it.
      fonts = mkOption {
        type = types.listOf types.path;
        default = [];
        example = literalExample "[ pkgs.fonts.dejavu_fonts ]";
        description = "List of primary font paths.";
      };

      enableDefaultFonts = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable a basic set of fonts providing several font styles
          and families and reasonable coverage of Unicode.
        '';
      };

    };

  };

  config = {

    fonts.fonts = mkIf config.fonts.enableDefaultFonts
      [
        pkgs.xorg.fontbhlucidatypewriter100dpi
        pkgs.xorg.fontbhlucidatypewriter75dpi
        pkgs.fonts.dejavu_fonts
        pkgs.fonts.freefont_ttf
        pkgs.fonts.liberation_ttf
        pkgs.xorg.fontbh100dpi
        pkgs.xorg.fontmiscmisc
        pkgs.xorg.fontcursormisc
        pkgs.fonts.unifont
      ];

  };

}
