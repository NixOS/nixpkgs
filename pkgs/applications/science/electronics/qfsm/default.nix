{ stdenv, fetchurl, qt4, cmake, graphviz, pkgconfig }:

stdenv.mkDerivation rec {
  name = "qfsm-0.53.0";

  src = fetchurl {
    url = "mirror://sourceforge/qfsm/${name}-Source.tar.bz2";
    sha256 = "1fx99dyai8zhs8s6mbr1i1467mnv1pf0ymh6mr0jm68mzj2jyzx4";
  };

  buildInputs = [ qt4 cmake graphviz pkgconfig ];

  patches = [ ./drop-hardcoded-prefix.patch ];

  enableParallelBuilding = true;

  meta = {
    description = "Graphical editor for finite state machines";
    homepage = "http://qfsm.sourceforge.net/";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
