{
  autoreconfHook,
  cups,
  fetchFromGitHub,
  ghostscript,
  libcupsfilters,
  libz,
  mupdf,
  pkg-config,
  poppler_utils,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libppd";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "libppd";
    rev = version;
    hash = "sha256-vT4h3dnMu4yHNk0ExGZjuChdu0kAcxsla7vJupZpLaY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    cups
  ];
  buildInputs = [
    ghostscript
    libcupsfilters
    mupdf
    libz
  ];
  configureFlags = [
    "--with-mutool-path=${mupdf}/bin/mutool"
    "--with-pdftops=pdftops"
    "--with-pdftops-path=${poppler_utils}/bin/pdftops"
    "--with-gs-path=${ghostscript}/bin/gs"
    "--with-pdftocairo-path=${poppler_utils}/bin/pdftocairo"
  ];
  makeFlags = [
    "CUPS_SERVERBIN=$(out)/lib/cups"
    "CUPS_DATADIR=$(out)/share/cups"
    "CUPS_SERVERROOT=$(out)/etc/cups"
  ];
}
