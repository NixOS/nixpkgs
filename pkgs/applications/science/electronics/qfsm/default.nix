{ stdenv, fetchurl, qt4, cmake, graphviz, pkgconfig }:

stdenv.mkDerivation rec {
  name = "qfsm-0.54.0";

  src = fetchurl {
    url = "mirror://sourceforge/qfsm/${name}-Source.tar.bz2";
    sha256 = "0rl7bc5cr29ng67yij4akciyid9z7npal812ys4c3m229vjvflrb";
  };

  buildInputs = [ qt4 cmake graphviz pkgconfig ];

  patches = [ ./drop-hardcoded-prefix.patch ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  meta = {
    description = "Graphical editor for finite state machines";
    homepage = http://qfsm.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
