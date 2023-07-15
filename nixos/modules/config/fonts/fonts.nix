{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.fonts;

  defaultFonts =
    [ pkgs.dejavu_fonts
      pkgs.freefont_ttf
      pkgs.gyre-fonts # TrueType substitutes for standard PostScript fonts
      pkgs.liberation_ttf
      pkgs.unifont
      pkgs.noto-fonts-emoji
    ];
in
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
        example = literalExpression "[ pkgs.dejavu_fonts ]";
        description = lib.mdDoc "List of primary font paths.";
      };

      enableDefaultFonts = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable a basic set of fonts providing several font styles
          and families and reasonable coverage of Unicode.
        '';
      };
    };

  };

  config = { fonts.fonts = mkIf cfg.enableDefaultFonts defaultFonts; };
}
