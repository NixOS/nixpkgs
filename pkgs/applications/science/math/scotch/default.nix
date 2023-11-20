{ lib, stdenv, fetchurl, bison, mpi, flex, zlib}:

stdenv.mkDerivation rec {
  version = "6.1.1";
  pname = "scotch";
  src_name = "scotch_${version}";

  buildInputs = [ bison mpi flex zlib ];

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/34618/${src_name}.tar.gz";
    sha256 = "sha256-OQUvWf9HSkppzvwlzzyvhClACIneugEO5kA8oYj4sxE=";
  };

  sourceRoot = "${src_name}/src";

  preConfigure = ''
    ln -s Make.inc/Makefile.inc.x86-64_pc_linux2 Makefile.inc
  '';

  buildFlags = [ "scotch ptscotch" ];
  installFlags = [ "prefix=\${out}" ];

  meta = {
    description = "Graph and mesh/hypergraph partitioning, graph clustering, and sparse matrix ordering";
    longDescription = ''
      Scotch is a software package for graph and mesh/hypergraph partitioning, graph clustering,
      and sparse matrix ordering.
    '';
    homepage = "http://www.labri.fr/perso/pelegrin/scotch";
    license = lib.licenses.cecill-c;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };
}

