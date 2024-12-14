{
  autoreconfHook,
  cups,
  dbus,
  dejavu_fonts,
  fetchFromGitHub,
  fontconfig,
  ghostscript,
  lcms2,
  libexif,
  libjpeg,
  libpng,
  libtiff,
  mupdf,
  pkg-config,
  poppler,
  poppler_utils,
  qpdf,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libcupsfilters";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "libcupsfilters";
    rev = "2.1.0";
    hash = "sha256-tnQqM4stUJseDO9BG+PRUSFafjgpQQklTDsDsB9zQ4Y=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    cups
  ];
  buildInputs = [
    dbus
    fontconfig
    ghostscript
    lcms2
    libexif
    libjpeg
    libpng
    libtiff
    mupdf
    poppler
    poppler_utils
    qpdf
  ];
  configureFlags = [
    "--with-mutool-path=${mupdf}/bin/mutool"
    "--with-gs-path=${ghostscript}/bin/gs"
    "--with-ippfind-path=${cups}/bin/ippfind"
    "--enable-imagefilters"
    "--with-test-font-path=${dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf"
  ];
  makeFlags = [
    "CUPS_SERVERBIN=$(out)/lib/cups"
    "CUPS_DATADIR=$(out)/share/cups"
    "CUPS_SERVERROOT=$(out)/etc/cups"
  ];
}
