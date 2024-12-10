{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  themeVariants ? [ ],
  catppuccinColorVariants ? [ ],
  draculaColorVariants ? [ ],
  gruvboxColorVariants ? [ ],
  originalColorVariants ? [ ],
}:

let
  pname = "afterglow-cursors-recolored";

  availableThemeVariants = [
    "Catppuccin"
    "Dracula"
    "Gruvbox"
    "Original"
  ];

  availableColorVariants = {
    Catppuccin = [
      "Blue"
      "Flamingo"
      "Green"
      "Macchiato"
      "Maroon"
      "Mauve"
      "Peach"
      "Pink"
      "Red"
      "Rosewater"
      "Sapphire"
      "Sky"
      "Teal"
      "Yellow"
    ];
    Dracula = [
      "Cyan"
      "Green"
      "Orange"
      "Pink"
      "Purple"
      "Red"
      "Teddy"
      "Yellow"
    ];
    Gruvbox = [
      "Aqua"
      "Black"
      "Blue"
      "Gray"
      "Green"
      "Mojas84"
      "Orange"
      "Purple"
      "White"
    ];
    Original = [
      "Blue"
      "Purple"
      "joris"
      "joris2"
      "joris3"
      "joris4"
    ];
  };
in

lib.checkListOfEnum "${pname}: theme variants" availableThemeVariants themeVariants
  lib.checkListOfEnum
  "${pname}: catppuccin color variants"
  availableColorVariants.Catppuccin
  catppuccinColorVariants
  lib.checkListOfEnum
  "${pname}: dracula color variants"
  availableColorVariants.Dracula
  draculaColorVariants
  lib.checkListOfEnum
  "${pname}: gruvbox color variants"
  availableColorVariants.Gruvbox
  gruvboxColorVariants
  lib.checkListOfEnum
  "${pname}: original color variants"
  availableColorVariants.Original
  originalColorVariants

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "0-unstable-2023-10-04";

    src = fetchFromGitHub {
      owner = "TeddyBearKilla";
      repo = "Afterglow-Cursors-Recolored";
      rev = "940a5d30e52f8c827fa249d2bbcc4af889534888";
      hash = "sha256-GR+d+jrbeIGpqal5krx83PxuQto2PQTO3unQ+jaJf6s=";
    };

    installPhase =
      let
        dist = {
          Catppuccin = "cat";
          Dracula = "dracula";
          Gruvbox = "gruvbox";
        };
        withAlternate = xs: xs': if xs != [ ] then xs else xs';
        themeVariants' = withAlternate themeVariants availableThemeVariants;
        colorVariants = {
          Catppuccin = withAlternate catppuccinColorVariants availableColorVariants.Catppuccin;
          Dracula = withAlternate draculaColorVariants availableColorVariants.Dracula;
          Gruvbox = withAlternate gruvboxColorVariants availableColorVariants.Gruvbox;
          Original = withAlternate originalColorVariants availableColorVariants.Original;
        };
      in
      ''
        runHook preInstall

        mkdir -p $out/share/icons

        ${lib.concatMapStringsSep "\n" (
          theme:
          lib.concatMapStringsSep "\n" (color: ''
            ln -s \
              "$src/colors/${theme}/${color}/dist-${
                lib.optionalString (theme != "Original") (dist.${theme} + "-")
              }${lib.toLower color}" \
              "$out/share/icons/Afterglow-Recolored-${theme}-${color}"
          '') colorVariants.${theme}
        ) themeVariants'}

        runHook postInstall
      '';

    meta = with lib; {
      description = "A recoloring of the Afterglow Cursors x-cursor theme";
      homepage = "https://github.com/TeddyBearKilla/Afterglow-Cursors-Recolored";
      maintainers = with maintainers; [ d3vil0p3r ];
      platforms = platforms.all;
      license = licenses.gpl3Plus;
    };
  }
