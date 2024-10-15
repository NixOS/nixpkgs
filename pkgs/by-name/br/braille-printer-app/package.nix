{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  cups,
  liblouis,
}:

stdenv.mkDerivation rec {
  pname = "braille-printer-app";
  version = "0-unstable-2022-11-25";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "braille-printer-app";
    rev = "9304787c0797c5d99a5a0d17493c9c2b21865bc8";
    hash = "sha256-kq1zIqp26I5/4De5PxvDEulhlzn5mQ2HnDNzO6H4Dac=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cups
    liblouis
  ];

  postConfigure = ''
    # Patch shebangs of generated build scripts
    patchShebangs filter
  '';

  makeFlags = [
    "CUPS_SERVERBIN=$(out)/lib/cups"
    "CUPS_DATADIR=$(out)/share/cups"
    "CUPS_SERVERROOT=$(out)/etc/cups"
  ];

  meta = with lib; {
    description = "OpenPrinting Braille Printer Application";
    homepage = "https://github.com/OpenPrinting/braille-printer-app";
    license = licenses.asl20;
    maintainers = with maintainers; [ tmarkus ];
    platforms = platforms.unix;
  };
}
