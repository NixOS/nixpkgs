{ lib
, stdenv
, fetchurl
, fltk13
, libjpeg
, pkg-config
}:

stdenv.mkDerivation rec {
  version = "4.0.19";
  pname = "flmsg";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "sha256-Pm5qAUNbenkX9V3OSQWW09iIRR/WB1jB4ioyRCZmjqs=";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Digital modem message program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
  };
}
