{ stdenv, fetchurl, cmake, pkgconfig, alsaLib, libjack2, qt4 }:

stdenv.mkDerivation rec {
  pname = "vmpk";
  version = "0.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tar.bz2";
    sha256 = "11fqnxgs9hr9255d93n7lazxzjwn8jpmn23nywdksh0pb1ffvfrc";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ alsaLib libjack2 qt4 ];

  meta = with stdenv.lib; {
    description = "Virtual MIDI Piano Keyboard";
    homepage = "http://vmpk.sourceforge.net/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
