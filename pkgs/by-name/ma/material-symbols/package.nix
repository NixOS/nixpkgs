{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2026-08-14";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "e083cc60a0828fdd3b404cea0cb8a5b900e9c23e";
    hash = "sha256-BC/4zMNGaCZL8SffVQ8UrVEgThA1Th1hLoC5v3R33NE=";
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
