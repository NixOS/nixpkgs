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
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "db9052";
    repo = "pdf2svg";
    rev = "v${version}";
    sha256 = "sha256-zME0U+PyENnoLyjo9W2i2MRM00wNmHkYcR2LMEtTbBY=";
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

  meta = with lib; {
    description = "PDF converter to SVG format";
    homepage = "http://www.cityinthesky.co.uk/opensource/pdf2svg";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ianwookim ];
    platforms = platforms.unix;
    mainProgram = "pdf2svg";
  };
}
