{
  autoreconfHook,
  avahi,
  cups,
  fetchFromGitHub,
  glib,
  lib,
  libcupsfilters,
  libppd,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "cups-browsed";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "cups-browsed";
    rev = version;
    hash = "sha256-Cfk28rxxgzzQs7B+tNmeUzDYL1eCx9zYwRsS/J6QX9s=";
  };

  nativeBuildInputs = [
    autoreconfHook
    cups
    glib # Required for gdbus-codegen
    pkg-config
  ];

  buildInputs = [
    avahi
    cups
    glib
    libcupsfilters
    libppd
  ];

  configureFlags = [
    "--with-rcdir=no"
  ];

  makeFlags = [
    "CUPS_SERVERBIN=$(out)/lib/cups"
    "CUPS_DATADIR=$(out)/share/cups"
    "CUPS_SERVERROOT=$(out)/etc/cups"
  ];

  meta = {
    description = "Daemon for browsing the Bonjour broadcasts of shared, remote CUPS printers";
    homepage = "https://github.com/OpenPrinting/cups-browsed";
    license = lib.licenses.asl20;
    mainProgram = "cups-browsed";
    platforms = lib.platforms.linux;
  };
}
