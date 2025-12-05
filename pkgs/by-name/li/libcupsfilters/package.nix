{
  autoreconfHook,
  cups,
  dbus,
  dejavu_fonts,
  fetchFromGitHub,
  fetchpatch,
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
  poppler-utils,
  qpdf,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "libcupsfilters";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "libcupsfilters";
    rev = "2.1.1";
    hash = "sha256-WEcg+NSsny/N1VAR1ejytM+3nOF3JlNuIUPf4w6N2ew=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/OpenPrinting/cups-filters/security/advisories/GHSA-893j-2wr2-wrh9
      name = "CVE-2025-64503.patch";
      url = "https://github.com/OpenPrinting/libcupsfilters/commit/fd01543f372ca3ba1f1c27bd3427110fa0094e3f.patch";
      # File has been renamed before the fix
      decode = "sed -e 's/pdftoraster\.c/pdftoraster\.cxx/g'";
      hash = "sha256-cKbDHZEc/A51M+ce3kVsRxjRUWA96ynGv/avpq4iUHU=";
    })
    (fetchpatch {
      # https://github.com/OpenPrinting/libcupsfilters/security/advisories/GHSA-jpxg-qc2c-hgv4
      # https://github.com/OpenPrinting/libcupsfilters/security/advisories/GHSA-rc6w-jmvv-v7gx
      # https://github.com/OpenPrinting/libcupsfilters/security/advisories/GHSA-fmvr-45mx-43c6
      name = "CVE-2025-57812.patch";
      url = "https://github.com/OpenPrinting/libcupsfilters/commit/b69dfacec7f176281782e2f7ac44f04bf9633cfa.patch";
      hash = "sha256-rPUbgtTu7j3uUZrtUhUPO1vFbV6naxIWsHf6x3JhS74=";
    })
  ];

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
    poppler-utils
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
