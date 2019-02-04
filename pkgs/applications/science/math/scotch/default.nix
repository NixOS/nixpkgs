{ stdenv, fetchurl, bison, openmpi, flex, zlib, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  version = "6.0.4";
  name = "scotch-${version}";
  src_name = "scotch_${version}";

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs = [ bison openmpi flex zlib ];

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/34618/${src_name}.tar.gz";
    sha256 = "f53f4d71a8345ba15e2dd4e102a35fd83915abf50ea73e1bf6efe1bc2b4220c7";
  };

  sourceRoot = "${src_name}/src";

  preConfigure = ''
    substituteInPlace Makefile \
      --replace '-$(CP) -f ../include/*scotch*.h $(includedir)' '-$(CP) -f ../include/*.h $(includedir)' \
      --replace '-$(CP) -f ../lib/*scotch*$(LIB) $(libdir)' '-$(CP) -f ../lib/*$(LIB) $(libdir)'

    ln -s Make.inc/Makefile.inc.x86-64_pc_linux2.shlib Makefile.inc
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.inc \
      --replace gcc mpicc \
      --replace "-DSCOTCH_PTHREAD " "" \
      --replace "-DCOMMON_PTHREAD" "-DCOMMON_PTHREAD -DCOMMON_PTHREAD_BARRIER" \
      --replace "-lrt" "" \
      --replace "-shared" "-dynamiclib -undefined dynamic_lookup" \
      --replace ".so" ".dylib"
  '';

  buildFlags = [ "scotch ptscotch esmumps ptesmumps" ];
  installFlags = [ "prefix=\${out} scotch ptscotch esmumps ptesmumps" ];

  meta = {
    description = "Graph and mesh/hypergraph partitioning, graph clustering, and sparse matrix ordering";
    longDescription = ''
      Scotch is a software package for graph and mesh/hypergraph partitioning, graph clustering,
      and sparse matrix ordering.
    '';
    homepage = http://www.labri.fr/perso/pelegrin/scotch;
    license = stdenv.lib.licenses.cecill-c;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
