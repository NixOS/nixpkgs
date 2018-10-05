{ stdenv
, fetchurl
, fltk13
, libjpeg
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "1.3.40";
  pname = "flrig";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${name}.tar.gz";
    sha256 = "1wr7bb2577gha7y3a8m5w60m4xdv8m0199cj2c6349sgbds373w9";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  meta = {
    description = "Digital modem rig control program";
    homepage = https://sourceforge.net/projects/fldigi/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ dysinger ];
    platforms = stdenv.lib.platforms.linux;
  };
}
