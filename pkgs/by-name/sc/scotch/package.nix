{
  bison,
  bzip2,
  cmake,
  fetchFromGitLab,
  flex,
  gfortran,
  lib,
  mpi,
  stdenv,
  zlib,
  xz,
  withPtScotch ? !stdenv.hostPlatform.isMusl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scotch";
  version = "7.0.8";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "scotch";
    repo = "scotch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AtpaBxgV9EamkAlvH9psp+K0o923EhSu6LQA89qyG3w=";
  };

  patches = [
    ./musl.patch
  ];

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_PTSCOTCH" withPtScotch)
  ];

  nativeBuildInputs = [
    cmake
    gfortran
    bison
    flex
  ]
  ++ lib.optionals withPtScotch [
    mpi
  ];

  buildInputs = [
    bzip2
    xz
    zlib
  ];

  strictDeps = true;

  meta = {
    description = "Graph and mesh/hypergraph partitioning, graph clustering, and sparse matrix ordering";
    longDescription = ''
      Scotch is a software package for graph and mesh/hypergraph partitioning, graph clustering,
      and sparse matrix ordering.
    '';
    homepage = "http://www.labri.fr/perso/pelegrin/scotch";
    license = lib.licenses.cecill-c;
    maintainers = [ lib.maintainers.bzizou ];
  };
})
