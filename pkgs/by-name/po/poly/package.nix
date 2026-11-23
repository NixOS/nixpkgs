{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "poly";
  version = "0-unstable-2026-03-25";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "6032a8073954d9a94207b25b0d682592375f4625";
    hash = "sha256-XQlJciU6GTmfXwnBngICwod2zysS209OBb1/tnynv48=";
    rootDir = "ofl/poly";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Medium contrast serif font";
    longDescription = ''
      With short ascenders and a very high x-height, Poly is efficient in small
      sizes. It was designed for agglutinative languages with very long words,
      so it tolerates cramped tracking and fits more letters on a line.
      Poly supports the Latin script and its variants.
    '';
    homepage = "https://fonts.google.com/specimen/Poly";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ iamanaws ];
    platforms = lib.platforms.all;
  };
}
