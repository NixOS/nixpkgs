{ stdenv
, fetchurl
, fltk13
, libjpeg
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "1.3.51";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "0aq4x0ai9q08ypfhzfj2inc4z3q39zq1l6h9as1kil9yn4zbay61";
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
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ dysinger ];
    platforms = stdenv.lib.platforms.linux;
  };
}
