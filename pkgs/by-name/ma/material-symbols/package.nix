{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2026-09-04";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "0cbb08816df07faaae3dca060d4ebb10b66c214f";
    hash = "sha256-txiQOwvz7rDHtGLuZmVUT8QpmTLEhvJUr5zqAmuYE5A=";
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
