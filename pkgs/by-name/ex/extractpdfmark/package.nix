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

  patches = [
    ./gettext-0.25.patch
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    poppler
  ];

  doCheck = true;

  nativeCheckInputs = [
    ghostscript
    texlive.combined.scheme-minimal
  ];

  meta = with lib; {
    homepage = "https://github.com/trueroad/extractpdfmark";
    description = "Extract page mode and named destinations as PDFmark from PDF";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.samueltardieu ];
    platforms = platforms.all;
    mainProgram = "extractpdfmark";
  };
}
