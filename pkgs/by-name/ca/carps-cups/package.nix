{
  stdenv,
  lib,
  fetchFromGitHub,
  cups,
}:

stdenv.mkDerivation {
  pname = "carps-cups";
  version = "unstable-2018-03-05";

  src = fetchFromGitHub {
    owner = "ondrej-zary";
    repo = "carps-cups";
    rev = "18d80d1d6f473dd9132e4b6d8b5c592c74982f17";
    sha256 = "0mjj9hs5lqxi0qamgb4sxfz4fvf7ggi66bxd37bkz3fl0g9xff70";
  };

  preBuild = ''
    export CUPS_DATADIR="${cups}/share/cups"
  '';

  installPhase = ''
    CUPSDIR="$out/lib/cups"
    CUPSDATADIR="$out/share/cups"

    mkdir -p "$CUPSDIR/filter" "$CUPSDATADIR/drv" "$CUPSDATADIR/usb"

    install -s rastertocarps $CUPSDIR/filter
    install -m 644 carps.drv $CUPSDATADIR/drv/
    install -m 644 carps.usb-quirks $CUPSDATADIR/usb/
  '';

  buildInputs = [ cups ];

  meta = with lib; {
    description = "CUPS Linux drivers for Canon printers";
    homepage = "https://www.canon.com/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      ewok
    ];
  };
}
