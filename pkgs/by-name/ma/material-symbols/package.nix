{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2026-10-09";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "49d4db35df873165d6bd6ba09b063c7dafbac2f4";
    hash = "sha256-xFC3/f2BfE4+99Ui/9HycV9CRzudBCXCdSOs8PG/aus=";
    sparseCheckout = [ "variablefont" ];
  };

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [ installFonts ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Material Symbols icons by Google";
    homepage = "https://fonts.google.com/icons";
    downloadPage = "https://github.com/google/material-design-icons";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fufexan
      luftmensch-luftmensch
      alexphanna
    ];
    platforms = lib.platforms.all;
  };
}
