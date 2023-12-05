{ lib
, stdenv
, fetchurl
, fltk13
, libjpeg
, eudev
, pkg-config
}:

stdenv.mkDerivation rec {
  version = "2.0.04";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "sha256-+AcQ7l1RXFDVVraYySBUE/+ZCyCOMiM2L4LyRXFquUc=";
  };

  buildInputs = [
    fltk13
    libjpeg
    eudev
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Digital modem rig control program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
  };
}
