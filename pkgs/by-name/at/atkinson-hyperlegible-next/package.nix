{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "atkinson-hyperlegible-next";
  version = "2.001-unstable-2025-02-21";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "atkinson-hyperlegible-next";
    rev = "7925f50f649b3813257faf2f4c0b381011f434f1";
    hash = "sha256-LhwfYI5Z6BhO7OaY/RwXT7r3WYiUY9AO2HL3MmhPpQY=";
  };

  dontBuild = true;

  nativeBuildInputs = [ installFonts ];

  # default installPhase invokes python, but we still want the font hook to run
  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    description = "New (2024) second version of the Atkinson Hyperlegible fonts";
    homepage = "https://www.brailleinstitute.org/freefont/";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
}
