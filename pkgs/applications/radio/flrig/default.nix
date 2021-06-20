{ lib
, stdenv
, fetchurl
, fltk13
, libjpeg
, pkg-config
}:

stdenv.mkDerivation rec {
  version = "1.4.0";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "sha256-CrIDk6cZlB+otO9CWFH7dIO6S3RUuhLLOcb+hkiGCwc=";
  };

  buildInputs = [
    fltk13
    libjpeg
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
