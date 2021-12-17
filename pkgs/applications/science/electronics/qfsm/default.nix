{ lib, stdenv, fetchurl, qt4, cmake, graphviz, pkg-config }:

stdenv.mkDerivation rec {
  pname = "qfsm";
  version = "0.54.0";

  src = fetchurl {
    url = "mirror://sourceforge/qfsm/qfsm-${version}-Source.tar.bz2";
    sha256 = "0rl7bc5cr29ng67yij4akciyid9z7npal812ys4c3m229vjvflrb";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ qt4 graphviz ];

  patches = [
    ./drop-hardcoded-prefix.patch
    ./gcc6-fixes.patch
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Graphical editor for finite state machines";
    homepage = "http://qfsm.sourceforge.net/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
