{ lib
, stdenv
, fetchurl
, fltk13
, libjpeg
, pkg-config
}:

stdenv.mkDerivation rec {
  version = "4.0.17";
  pname = "flmsg";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "09xf3f65d3qi69frznf4fdznbfbc7kmgxw716q2c7ccsmh9c5q44";
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
