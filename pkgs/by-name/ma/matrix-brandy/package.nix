{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL,
}:

stdenv.mkDerivation rec {
  pname = "matrix-brandy";
  version = "1.23.3";

  src = fetchFromGitHub {
    owner = "stardot";
    repo = "MatrixBrandy";
    rev = "V${version}";
    hash = "sha256-jw5SxCQ2flvCjO/JO3BHpnpt31wBsBxDkVH7uwVxTS0=";
  };

  buildInputs = [
    SDL
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp brandy $out/bin
  '';

  meta = {
    homepage = "http://brandy.matrixnetwork.co.uk/";
    description = "Matrix Brandy BASIC VI for Linux, Windows, MacOSX";
    mainProgram = "brandy";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fiq ];
  };
}
