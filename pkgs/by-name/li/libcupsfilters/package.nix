{
  autoreconfHook,
  cups,
  dbus,
  dejavu_fonts,
  fetchFromGitHub,
  fontconfig,
  ghostscript,
  lcms2,
  lib,
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
  ];
  buildInputs = [
    cups
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
    "--with-cups-config=${lib.getExe' (lib.getDev cups) "cups-config"}"
    "--with-mutool-path=${lib.getExe' mupdf "mutool"}"
    "--with-gs-path=${lib.getExe ghostscript}"
    "--with-ippfind-path=${lib.getExe' cups "ippfind"}"
    "--enable-imagefilters"
    "--with-test-font-path=${dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf"
  ];
  makeFlags = [
    "CUPS_SERVERBIN=$(out)/lib/cups"
    "CUPS_DATADIR=$(out)/share/cups"
    "CUPS_SERVERROOT=$(out)/etc/cups"
  ];

  meta = {
    homepage = "https://github.com/OpenPrinting/libcupsfilters";
    description = "Backends, filters, and other software that was once part of the core CUPS distribution but is no longer maintained by Apple Inc";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
