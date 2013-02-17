{ stdenv, fetchurl, fetchsvn, cmake, qt4, mesa, opentrace_format, libtau }:

# ViTE 1.1 has several bugs, so use the SVN version.
let
  rev = "1157";
  externals = fetchsvn {
    url = "svn://scm.gforge.inria.fr/svn/vite/externals";
    sha256 = "1yqx72q3dd53k8z6jz93nbm9yyysq4npdjh1qv3f1qcrpz75k1zj";
    inherit rev;
  };
in
stdenv.mkDerivation {
  name = "vite-1.2";

  src = fetchurl {
    url = "http://gforge.inria.fr/frs/download.php/27457/vite_${rev}.tar.gz";
    sha256 = "0j894wpqgcy0dzsxrp0z2fzymcl1m406cy4xv1kdzada25zjaq7m";
  };

  patches = [ ./larger-line-buffer.patch ];
  preConfigure = "sed -i '50i\#include <GL/glu.h>' src/render/Geometry.hpp";

  cmakeFlags = "-DTAU_LIBRARY=${libtau}/lib/libTAU.so -DTAU_INCLUDE_DIR=${libtau}/include"; # -DTAU_DIR:PATH=${libtau}";

  buildInputs = [ cmake qt4 mesa opentrace_format libtau ];

  NIX_LDFLAGS = "-lGLU";

  meta = {
    description = "Visual Trace Explorer (ViTE), a tool to visualize execution traces";

    longDescription =
      '' ViTE is a trace explorer. It is a tool to visualize execution traces
         in Pajé or OTF format for debugging and profiling parallel or
         distributed applications.
      '';

    homepage = http://vite.gforge.inria.fr/;

    license = "CeCILL-A";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
