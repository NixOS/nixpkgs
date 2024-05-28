{
  lib,
  stdenv,
  fetchFromGitLab,
  bison,
  mpi,
  flex,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scotch";
  version = "7.0.4";

  buildInputs = [
    bison
    mpi
    flex
    zlib
  ];

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "scotch";
    repo = "scotch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uaox4Q9pTF1r2BZjvnU2LE6XkZw3x9mGSKLdRVUobGU=";
  };

  preConfigure = ''
    cd src
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
})
