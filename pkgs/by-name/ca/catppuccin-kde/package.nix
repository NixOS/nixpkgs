{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch,
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
    version = "0.2.6";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-pfG0L4eSXLYLZM8Mhla4yalpEro74S9kc0sOmQtnG3w=";
    };

    patches = [
      (fetchpatch {
        url = "https://github.com/GiggleSquid/catppuccin-kde/commit/f0291c17d2e4711b0d0aac00e3dbb94ee89b4a82.patch";
        hash = "sha256-iD+mEX2LRFmrCwLr3VAs6kzcTuZ231TKDn+U188iOss=";
      })
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

    meta = with lib; {
      description = "Soothing pastel theme for KDE";
      homepage = "https://github.com/catppuccin/kde";
      license = licenses.mit;
      maintainers = with maintainers; [
        michaelBelsanti
        gigglesquid
      ];
    };
  }
