{ stdenv
, fetchurl
, fltk13
, libjpeg
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "1.3.45";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "14rnyqwlk35j2027l7hxfig6v7j7302w4vsvx0l33b782i8phs2v";
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
