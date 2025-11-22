{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  gfortran,
  blas,
  lapack,
  mpi,
  llvmPackages,
  mpiCheckPhaseHook,
  isILP64 ? false,
  mpiSupport ? true,
  fortranSupport ? true,
  precision ? "double",
  testers,
  hypre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypre";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "hypre-space";
    repo = "hypre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zu9YWfBT2WJxPg6JHrXjZWRM9Ai1p28EpvAx6xfdPsY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/spack/spack-packages/eb4b23847f0079d0c9c8de99aaa32557ad4c9194/repos/builtin/packages/hypre/hypre-precision-fix.patch?full_index=1";
      hash = "sha256-Ni5xlfFmok884x5Hctf9VOsAgZp8ICG7QNVGTdVKPzE=";
    })
  ];

  # fix sequence check
  postPatch = ''
    substituteInPlace src/test/CMakeLists.txt \
      --replace-fail ''\'''${MPIEXEC_EXECUTABLE} ''${MPIEXEC_NUMPROC_FLAG} 1' ""
  '';

  preConfigure = ''
    cd src
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optional fortranSupport gfortran;

  propagatedBuildInputs = [
    (blas.override { inherit isILP64; })
    (lapack.override { inherit isILP64; })
  ]
  ++ lib.optional mpiSupport mpi
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BLA_PREFER_PKGCONFIG" true)
    (lib.cmakeBool "HYPRE_ENABLE_HYPRE_BLAS" false)
    (lib.cmakeBool "HYPRE_ENABLE_HYPRE_LAPACK" false)
    (lib.cmakeBool "HYPRE_ENABLE_FORTRAN" fortranSupport)
    (lib.cmakeBool "HYPRE_ENABLE_BIGINT" isILP64)
    (lib.cmakeBool "HYPRE_ENABLE_SINGLE" (precision == "single"))
    (lib.cmakeBool "HYPRE_ENABLE_LONG_DOUBLE" (precision == "__float128"))
    (lib.cmakeBool "HYPRE_ENABLE_OPENMP" true)
    (lib.cmakeBool "HYPRE_ENABLE_MPI" mpiSupport)
    (lib.cmakeBool "HYPRE_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  __darwinAllowLocalNetworking = mpiSupport;

  nativeCheckInputs = lib.optional mpiSupport mpiCheckPhaseHook;

  doCheck = true;

  postInstall = lib.optionalString finalAttrs.finalPackage.doCheck ''
    rm -rf $out/bin
  '';

  passthru = {
    tests = {
      cmake-config = testers.hasCmakeConfigModules {
        moduleNames = [ "HYPRE" ];
        package = finalAttrs.finalPackage;
      };
      ilp64 = hypre.override { isILP64 = true; };
      single = hypre.override { precision = "single"; };
    };
  };

  meta = {
    description = "Parallel solvers for sparse linear systems featuring multigrid methods";
    homepage = "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      mkez
      qbisi
    ];
  };
})
