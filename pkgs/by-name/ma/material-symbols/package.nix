{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "f3fb4442b2a9afbedfe68bfa1ed80f178ca4f10d";
    hash = "sha256-uL3wAkfFa1/gTvzkaK+qWrCLZI05mlF+grbhWYEERbY=";
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
