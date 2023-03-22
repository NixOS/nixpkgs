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
    (mkRenamedOptionModule [ "hardware" "video" "hidpi" "enable" ] [ "fonts" "optimizeForVeryHighDPI" ])
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

      optimizeForVeryHighDPI = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Optimize configuration for very high-density (>200 DPI) displays:
            - disable subpixel anti-aliasing
            - disable hinting
            - automatically upscale the default X11 cursor
        '';
      };
    };

  };

  config = mkMerge [
    { fonts.fonts = mkIf cfg.enableDefaultFonts defaultFonts; }
    (mkIf cfg.optimizeForVeryHighDPI {
      services.xserver.upscaleDefaultCursor = mkDefault true;
      # Conforms to the recommendation in fonts/fontconfig.nix
      # for > 200DPI.
      fonts.fontconfig = {
        antialias = mkDefault false;
        hinting.enable = mkDefault false;
        subpixel.lcdfilter = mkDefault "none";
      };
    })
  ];

}
