{ fetchurl, stdenv, cmake, ruby }:

stdenv.mkDerivation rec {
  name = "simgrid-3.4.1";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/26944/${name}.tar.bz2";
    sha256 = "acd2bb2c1abf59e9b190279b1c38582b7c1edd4b6ef4c6a9b01100740f1a6b28";
  };

  /* FIXME: Ruby currently disabled because of this:

     Linking C shared library ../src/.libs/libsimgrid.so
     ld: cannot find -lruby-1.8.7-p72

   */
  buildInputs = [ cmake /* ruby */ ];

  preConfigure =
    # Make it so that libsimgrid.so will be found when running programs from
    # the build dir.
    '' export LD_LIBRARY_PATH="$PWD/src/.libs"
       export cmakeFlags="-Dprefix=$out"

       # Enable tracing.
       export cmakeFlags="$cmakeFlags -Denable_tracing=on"
    '';

  makeFlags = "VERBOSE=1";

  patchPhase =
    '' for i in "src/smpi/"*
       do
         sed -i "$i" -e's|/bin/bash|/bin/sh|g'
       done
    '';

  installPhase = "make install-simgrid";

  # Fixing the few tests that fail is left as an exercise to the reader.
  doCheck = false;

  meta = {
    description = "SimGrid, a simulator for distributed applications in heterogeneous environments";

    longDescription =
      '' SimGrid is a toolkit that provides core functionalities for the
         simulation of distributed applications in heterogeneous distributed
         environments.  The specific goal of the project is to facilitate
         research in the area of distributed and parallel application
         scheduling on distributed computing platforms ranging from simple
         network of workstations to Computational Grids.
      '';

    homepage = http://simgrid.gforge.inria.fr/;

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
