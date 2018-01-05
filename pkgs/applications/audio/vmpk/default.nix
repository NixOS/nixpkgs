{ stdenv, fetchurl, cmake, pkgconfig
, qt5, libpthreadstubs, libXdmcp, drumstick, docbook_xsl, libjack2
}:

let
  version = "0.6.2";
in stdenv.mkDerivation rec {
  name = "vmpk-${version}";

  meta = with stdenv.lib; {
    description = "Virtual MIDI Piano Keyboard";
    homepage    = "http://vmpk.sourceforge.net/";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };

  src = fetchurl {
    url = "mirror://sourceforge/vmpk/${version}/${name}a.tar.bz2";
    sha256 = "0259iikvxnfdiifrh02g8xgcxikrkca4nhd3an8xzx0bd6bk8ifi";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ qt5.qtbase qt5.qtsvg qt5.qttools qt5.qtx11extras libpthreadstubs libXdmcp drumstick docbook_xsl libjack2 ];
}
