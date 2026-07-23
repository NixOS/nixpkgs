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
  mpiCheckPhaseHook,
  withPtScotch ? false,
  testers,
  pkgsMusl ? { }, # default to empty set to avoid CI fails with allowVariants = false
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scotch";
  version = "7.0.11";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "scotch";
    repo = "scotch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ljz4Xu3ztxhx8c+gRYABG85T9SuauQc4UsVHPmREvkk=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_PTSCOTCH" withPtScotch)
    # Prefix Scotch version of MeTiS routines
    (lib.cmakeBool "SCOTCH_METIS_PREFIX" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
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

  propagatedBuildInputs = lib.optionals withPtScotch [
    mpi
  ];

  nativeCheckInputs = lib.optionals withPtScotch [
    mpiCheckPhaseHook
  ];

  __darwinAllowLocalNetworking = withPtScotch;

  doCheck = true;

  # SCOTCH provide compatibility with Metis/Parmetis interface.
  # We install the metis compatible headers to subdirectory to
  # avoid conflict with metis/parmetis.
  postFixup = ''
    mkdir -p $dev/include/scotch
    mv $dev/include/{*metis,metisf}.h $dev/include/scotch
  '';

  passthru = {
    tests = {
      cmake-config = testers.hasCmakeConfigModules {
        moduleNames = [ "SCOTCH" ];
        package = finalAttrs.finalPackage;
      };
      musl = pkgsMusl.scotch or null;
    };

    updateScript = nix-update-script { };
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
