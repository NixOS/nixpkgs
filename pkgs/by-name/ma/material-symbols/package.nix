{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2026-06-05";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "27aa4d49e4fabcb2a7f3acc86d205d33b159fad3";
    hash = "sha256-l8uXZZZ0rtQIYiEua8xmpuacLiR8hVjclAyc9dUI8z8=";
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
