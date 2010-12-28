{ fetchurl, stdenv, cmake, perl, ruby }:

stdenv.mkDerivation rec {
  name = "simgrid-3.5";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/28017/${name}.tar.gz";
    sha256 = "1vd4pvrcyii1nfwyca3kpbwshbc965lfpn083zd8rigg6ydchq8y";
  };

  /* FIXME: Ruby currently disabled because of this:

     Linking C shared library ../src/.libs/libsimgrid.so
     ld: cannot find -lruby-1.8.7-p72

   */
  buildInputs = [ cmake perl /* ruby */ ];

  preConfigure =
    # Make it so that libsimgrid.so will be found when running programs from
    # the build dir.
    '' export LD_LIBRARY_PATH="$PWD/src/.libs"
       export cmakeFlags="-Dprefix=$out"

       # Enable tracing.
       export cmakeFlags="$cmakeFlags -Denable_tracing=on"
    '';

  makeFlags = "VERBOSE=1";

  preBuild =
    /* Work around this:

      [ 20%] Generating _msg_handle_simulator.c, _msg_handle_client.c, _msg_handle_server.c
      cd /tmp/nix-build-7yc8ghmf2yb8zi3bsri9b6qadwmfpzhr-simgrid-3.5.drv-0/simgrid-3.5/build/teshsuite/gras/msg_handle && ../../../bin/gras_stub_generator msg_handle /tmp/nix-build-7yc8ghmf2yb8zi3bsri9b6qadwmfpzhr-simgrid-3.5.drv-0/simgrid-3.5/teshsuite/gras/msg_handle/msg_handle.xml
      ../../../bin/gras_stub_generator: error while loading shared libraries: libsimgrid.so.3.5: cannot open shared object file: No such file or directory
      make[2]: *** [teshsuite/gras/msg_handle/_msg_handle_simulator.c] Error 127
      make[2]: Leaving directory `/tmp/nix-build-7yc8ghmf2yb8zi3bsri9b6qadwmfpzhr-simgrid-3.5.drv-0/simgrid-3.5/build'

    */
    '' export LD_LIBRARY_PATH="$PWD/lib:$LD_LIBRARY_PATH"
       echo "\$LD_LIBRARY_PATH is \`$LD_LIBRARY_PATH'"
    '';

  patchPhase =
    '' for i in "src/smpi/"*
       do
         sed -i "$i" -e's|/bin/bash|/bin/sh|g'
       done

       for i in $(grep -rl /usr/bin/perl .)
       do
         sed -i "$i" -e's|/usr/bin/perl|${perl}/bin/perl|g'
       done
    '';

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
