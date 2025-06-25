{
  autoreconfHook,
  cups,
  fetchFromGitHub,
  ghostscript,
  libcupsfilters,
  libz,
  mupdf,
  pkg-config,
  poppler-utils,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libppd";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "libppd";
    rev = version;
    hash = "sha256-8ofCv+tKgBk9GoGD4lmBPB/S4ABZ6cWGOk/KqDsEzNk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    cups
  ];
  buildInputs = [
    cups
    ghostscript
    libcupsfilters
    mupdf
    libz
  ];
  configureFlags = [
    "--with-mutool-path=${mupdf}/bin/mutool"
    "--with-pdftops=pdftops"
    "--with-pdftops-path=${poppler-utils}/bin/pdftops"
    "--with-gs-path=${ghostscript}/bin/gs"
    "--with-pdftocairo-path=${poppler-utils}/bin/pdftocairo"
  ];
  makeFlags = [
    "CUPS_SERVERBIN=$(out)/lib/cups"
    "CUPS_DATADIR=$(out)/share/cups"
    "CUPS_SERVERROOT=$(out)/etc/cups"
  ];
}
