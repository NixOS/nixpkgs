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
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "cups-browsed";
    rev = version;
    hash = "sha256-UkPJqVWG6obIW0jGXsnnYB2lmIm/uiMuPYSGY3+M4Gw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    cups
  ];

  buildInputs = [
    avahi
    libcupsfilters
    libppd
    glib
  ];

  configureFlags = [
    "--with-rcdir=no"
  ];

  makeFlags = [
    "CUPS_SERVERBIN=$(out)/lib/cups"
    "CUPS_DATADIR=$(out)/share/cups"
    "CUPS_SERVERROOT=$(out)/etc/cups"
  ];
}
