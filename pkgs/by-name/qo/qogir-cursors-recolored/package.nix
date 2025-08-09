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
  pname = "qogir-cursors-recolored";
  version = "0-unstable-2024-10-03";

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
      "Joris"
      "Joris2"
      "Joris3"
      "Joris4"
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
    inherit pname version;

    src = fetchFromGitHub {
      owner = "TeddyBearKilla";
      repo = "Qogir-Cursors-Recolored";
      rev = "0d2c6be805cb5b8744faa6d046c5b50e90e71a06";
      hash = "sha256-MomchdS1H5EmjhNUp0khaPxXE5CYoP8WlGgYEhXU21A=";
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
              "$out/share/icons/Qogir-Recolored-${theme}-${color}"
          '') colorVariants.${theme}
        ) themeVariants'}

        runHook postInstall
      '';

    meta = with lib; {
      description = "Recoloring of the Qogir Cursors x-cursor theme";
      homepage = "https://github.com/TeddyBearKilla/Qogir-Cursors-Recolored";
      maintainers = with maintainers; [ mushrowan ];
      platforms = platforms.all;
      license = licenses.gpl3Plus;
    };
  }
