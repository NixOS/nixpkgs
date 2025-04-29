{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.fonts;
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "fonts"
      "enableCoreFonts"
    ] "Use fonts.packages = [ pkgs.corefonts ]; instead.")
    (lib.mkRenamedOptionModule [ "fonts" "enableDefaultFonts" ] [ "fonts" "enableDefaultPackages" ])
    (lib.mkRenamedOptionModule [ "fonts" "fonts" ] [ "fonts" "packages" ])
  ];

  options = {
    fonts = {
      packages = lib.mkOption {
        type = with lib.types; listOf path;
        default = [ ];
        example = lib.literalExpression "[ pkgs.dejavu_fonts ]";
        description = "List of primary font packages.";
      };

      enableDefaultPackages = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable a basic set of fonts providing several styles
          and families and reasonable coverage of Unicode.
        '';
      };
    };
  };

  config = {
    fonts.packages = lib.mkIf cfg.enableDefaultPackages (
      with pkgs;
      [
        dejavu_fonts
        freefont_ttf
        gyre-fonts # TrueType substitutes for standard PostScript fonts
        liberation_ttf
        unifont
        noto-fonts-color-emoji
      ]
    );
  };
}
