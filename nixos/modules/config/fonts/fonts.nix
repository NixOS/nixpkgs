{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    (mkRemovedOptionModule [ "fonts" "enableCoreFonts" ] "Use fonts.fonts = [ pkgs.corefonts ]; instead.")
  ];

  options = {

    fonts = {

      # TODO: find another name for it.
      fonts = mkOption {
        type = types.listOf types.path;
        default = [];
        example = literalExample "[ pkgs.dejavu_fonts ]";
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
      ([
        pkgs.dejavu_fonts
        pkgs.freefont_ttf
        pkgs.gyre-fonts # TrueType substitutes for standard PostScript fonts
        pkgs.liberation_ttf
        pkgs.xorg.fontmiscmisc
        pkgs.xorg.fontcursormisc
        pkgs.unifont
        pkgs.noto-fonts-emoji
      ] ++ lib.optionals (config.nixpkgs.config.allowUnfree or false) [
        # these are unfree, and will make usage with xserver fail
        pkgs.xorg.fontbhlucidatypewriter100dpi
        pkgs.xorg.fontbhlucidatypewriter75dpi
        pkgs.xorg.fontbh100dpi
      ]);

  };

}
