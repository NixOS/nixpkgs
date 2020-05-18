{ stdenv, fetchurl, cmake, pkgconfig
, qt4, libjack2
}:

let
  version = "0.5.1";
in stdenv.mkDerivation rec {
  pname = "vmpk";
  inherit version;

  meta = with stdenv.lib; {
    description = "Virtual MIDI Piano Keyboard";
    homepage    = "http://vmpk.sourceforge.net/";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };

  src = fetchurl {
    url = "mirror://sourceforge/vmpk/${version}/${pname}-${version}.tar.bz2";
    sha256 = "11fqnxgs9hr9255d93n7lazxzjwn8jpmn23nywdksh0pb1ffvfrc";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ qt4 libjack2 ];
}
