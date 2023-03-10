{ config, lib, pkgs, ... }:

with lib;

let
  # A scalable variant of the X11 "core" cursor
  #
  # If not running a fancy desktop environment, the cursor is likely set to
  # the default `cursor.pcf` bitmap font. This is 17px wide, so it's very
  # small and almost invisible on 4K displays.
  fontcursormisc_hidpi = pkgs.xorg.fontxfree86type1.overrideAttrs (old:
    let
      # The scaling constant is 230/96: the scalable `left_ptr` glyph at
      # about 23 points is rendered as 17px, on a 96dpi display.
      # Note: the XLFD font size is in decipoints.
      size = 2.39583 * config.services.xserver.dpi;
      sizeString = builtins.head (builtins.split "\\." (toString size));
    in
    {
      postInstall = ''
        alias='cursor -xfree86-cursor-medium-r-normal--0-${sizeString}-0-0-p-0-adobe-fontspecific'
        echo "$alias" > $out/lib/X11/fonts/Type1/fonts.alias
      '';
    });

  hasHidpi =
    config.hardware.video.hidpi.enable &&
    config.services.xserver.dpi != null;

  defaultFonts =
    [ pkgs.dejavu_fonts
      pkgs.freefont_ttf
      pkgs.gyre-fonts # TrueType substitutes for standard PostScript fonts
      pkgs.liberation_ttf
      pkgs.unifont
      pkgs.noto-fonts-emoji
    ];

  defaultXFonts =
    [ (if hasHidpi then fontcursormisc_hidpi else pkgs.xorg.fontcursormisc)
      pkgs.xorg.fontmiscmisc
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

  config = mkMerge [
    { fonts.fonts = mkIf config.fonts.enableDefaultFonts defaultFonts; }
    { fonts.fonts = mkIf config.services.xserver.enable defaultXFonts; }
  ];

}
