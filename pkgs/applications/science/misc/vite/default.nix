{ fetchurl, stdenv, cmake, qt, mesa }:

stdenv.mkDerivation {
  name = "vite-1.1";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/26321/vite_1005.tar.gz";
    sha256 = "11l39809i1hjizw89x23d6m246w7a64z11bhrx7q5h0scvwd1imr";
  };

  buildInputs = [ cmake qt mesa ];

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
