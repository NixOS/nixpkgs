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
  version = "6.1.1";

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
    hash = "sha256-GUV6s+P56OAJq9AMe+LZOMPICQO/RuIi+hJAecmO5Wc=";
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
