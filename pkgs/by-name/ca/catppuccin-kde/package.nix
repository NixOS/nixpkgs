{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  flavour ? [ "frappe" ],
  accents ? [ "blue" ],
  winDecStyles ? [ "modern" ],
}:

let
  validFlavours = [
    "mocha"
    "macchiato"
    "frappe"
    "latte"
  ];
  validAccents = [
    "rosewater"
    "flamingo"
    "pink"
    "mauve"
    "red"
    "maroon"
    "peach"
    "yellow"
    "green"
    "teal"
    "sky"
    "sapphire"
    "blue"
    "lavender"
  ];
  validWinDecStyles = [
    "modern"
    "classic"
  ];

  colorScript = ./color.sh;
in

lib.checkListOfEnum "Invalid accent, valid accents are ${toString validAccents}" validAccents
  accents
  lib.checkListOfEnum
  "Invalid flavour, valid flavours are ${toString validFlavours}"
  validFlavours
  flavour
  lib.checkListOfEnum
  "Invalid window decoration style, valid styles are ${toString validWinDecStyles}"
  validWinDecStyles
  winDecStyles

  stdenvNoCC.mkDerivation
  rec {
    pname = "kde";
    version = "0.3.1";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "kde";
      tag = "v${version}";
      hash = "sha256-+2z9uzWhnNIsaQm6MfHWduweKidb3HgJpgR5qobkf3c=";
    };

    patches = [
      ./install-script.patch
    ];

    installPhase = ''
      runHook preInstall
      patchShebangs .

      for WINDECSTYLE in ${toString winDecStyles}; do
        for FLAVOUR in ${toString flavour}; do
          for ACCENT in ${toString accents}; do
            source ${colorScript}
            ./install.sh $FLAVOUR $ACCENT $WINDECSTYLE
          done;
        done;
      done;

      runHook postInstall
    '';

    meta = {
      description = "Soothing pastel theme for KDE";
      homepage = "https://github.com/catppuccin/kde";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        michaelBelsanti
        gigglesquid
      ];
    };
  }
