{ stdenv
, fetchurl
, fltk13
, libjpeg
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "4.0.15";
  pname = "flmsg";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "1wyqp24jwlca1bgf4q8clx5rpvmf68svwbcp0pm7hdjsbpncbpjf";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  meta = {
    description = "Digital modem message program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ dysinger ];
    platforms = stdenv.lib.platforms.linux;
  };
}
