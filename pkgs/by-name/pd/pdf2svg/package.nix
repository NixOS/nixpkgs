{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  cairo,
  gtk2,
  poppler,
}:

stdenv.mkDerivation rec {
  pname = "pdf2svg";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "db9052";
    repo = "pdf2svg";
    rev = "v${version}";
    sha256 = "14ffdm4y26imq99wjhkrhy9lp33165xci1l5ndwfia8hz53bl02k";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    cairo
    poppler
    gtk2
  ];

  meta = {
    description = "PDF converter to SVG format";
    homepage = "http://www.cityinthesky.co.uk/opensource/pdf2svg";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.ianwookim ];
    platforms = lib.platforms.unix;
    mainProgram = "pdf2svg";
  };
}
