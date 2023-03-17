{ lib
, stdenv
, fetchurl
, fltk13
, libjpeg
, eudev
, pkg-config
}:

stdenv.mkDerivation rec {
  version = "1.4.7";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "sha256-RzyeJf3T1vKTlyU/EMXFY+ObkqKq7wJyBB8ZeKMOO1M=";
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
