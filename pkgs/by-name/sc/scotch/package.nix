{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gfortran,
  bison,
  flex,
  bzip2,
  xz,
  zlib,
  mpi,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scotch";
  version = "7.0.9";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "scotch";
    repo = "scotch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dbf18XdmDP0KgS4H4L7Wnam7kGF88yBcCvehYRRpHvA=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  nativeBuildInputs = [
    cmake
    gfortran
    bison
    flex
  ];

  buildInputs = [
    bzip2
    xz
    zlib
  ];

  propagatedBuildInputs = [
    mpi
  ];

  passthru = {
    tests = {
      cmake-config = testers.hasCmakeConfigModules {
        moduleNames = [ "SCOTCH" ];
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    description = "Graph and mesh/hypergraph partitioning, graph clustering, and sparse matrix ordering";
    longDescription = ''
      Scotch is a software package for graph and mesh/hypergraph partitioning, graph clustering,
      and sparse matrix ordering.
    '';
    homepage = "http://www.labri.fr/perso/pelegrin/scotch";
    license = lib.licenses.cecill-c;
    maintainers = with lib.maintainers; [
      bzizou
      qbisi
    ];
  };
})
