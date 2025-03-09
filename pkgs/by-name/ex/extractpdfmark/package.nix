{
  autoreconfHook,
  fetchFromGitHub,
  ghostscript,
  lib,
  pkg-config,
  poppler,
  stdenv,
  texlive,
}:

stdenv.mkDerivation rec {
  pname = "extractpdfmark";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "trueroad";
    repo = "extractpdfmark";
    rev = "v${version}";
    hash = "sha256-pNc/SWAtQWMbB2+lIQkJdBYSZ97iJXK71mS59qQa7Hs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    ghostscript
    poppler
    texlive.combined.scheme-minimal
  ];

  postPatch = ''
    touch config.rpath
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/trueroad/extractpdfmark";
    description = "Extract page mode and named destinations as PDFmark from PDF";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.samueltardieu ];
    platforms = platforms.all;
    mainProgram = "extractpdfmark";
  };
}
