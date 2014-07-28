{ stdenv, fetchurl, cmake, pkgconfig
, qt4, jackaudio
}:

let
  version = "0.5.1";
in stdenv.mkDerivation rec {
  name = "vmpk-${version}";

  meta = with stdenv.lib; {
    description = "Virtual MIDI Piano Keyboard";
    homepage    = "http://vmpk.sourceforge.net/";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/vmpk/${version}/${name}.tar.bz2";
    sha256 = "11fqnxgs9hr9255d93n7lazxzjwn8jpmn23nywdksh0pb1ffvfrc";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ qt4 jackaudio ];
}
