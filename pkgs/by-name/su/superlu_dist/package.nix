{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  llvmPackages,
  cmake,
  pkg-config,
  gfortran,
  blas,
  lapack,
  mpi,
  mpiCheckPhaseHook,
  metis,
  parmetis,
  # Todo: ask for permission of unfree parmetis
  withParmetis ? false,
  isILP64 ? false,

  # passthru.tests
  superlu_dist,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "superlu_dist";
  version = "9.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xiaoyeli";
    repo = "superlu_dist";
    tag = "v${finalAttrs.version}";
    # Remove non‐free files.
    postFetch = "rm $out/SRC/prec-independent/mc64ad_dist.c";
    hash = "sha256-i/Gg+9oMNNRlviwXUSRkWNaLRZLPWZRtA1fGYqh2X0k=";
  };

  patches = [
    ./mc64ad_dist-stub.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    gfortran
  ];

  buildInputs = [
    mpi
    # always build with lp64 BLAS/LAPACK.
    # see https://github.com/xiaoyeli/superlu_dist/issues/132#issuecomment-2323093701
    (blas.override { isILP64 = false; })
    (lapack.override { isILP64 = false; })
  ]
  ++ lib.optionals withParmetis [
    metis
    parmetis
  ]
  ++ lib.optionals stdenv.cc.isClang [
    gfortran.cc.lib
    llvmPackages.openmp
  ];

  cmakeFlags = [
    (lib.cmakeBool "enable_examples" false)
    (lib.cmakeBool "enable_openmp" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_STATIC_LIBS" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "XSDK_ENABLE_Fortran" true)
    (lib.cmakeBool "BLA_PREFER_PKGCONFIG" true)
    (lib.cmakeBool "TPL_ENABLE_INTERNAL_BLASLIB" false)
    (lib.cmakeBool "TPL_ENABLE_LAPACKLIB" true)
    (lib.cmakeBool "TPL_ENABLE_PARMETISLIB" withParmetis)
    (lib.cmakeFeature "XSDK_INDEX_SIZE" (if isILP64 then "64" else "32"))
  ]
  ++ lib.optionals withParmetis [
    (lib.cmakeFeature "TPL_PARMETIS_LIBRARIES" "-lmetis -lparmetis")
    (lib.cmakeFeature "TPL_PARMETIS_INCLUDE_DIRS" "${lib.getDev parmetis}/include")
  ];

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ mpiCheckPhaseHook ];

  passthru = {
    inherit isILP64;
    tests = {
      ilp64 = superlu_dist.override { isILP64 = true; };
    };
  };

  meta = {
    homepage = "https://portal.nersc.gov/project/sparse/superlu/";
    license = with lib.licenses; [
      # Files: *
      # Lawrence Berkeley National Labs BSD variant license
      bsd3Lbnl

      # Files: SRC/prec-independent/symbfact.c
      # Xerox code; actually `Boehm-GC` variant.
      mit

      # Files: SRC/include/*colamd.h
      # University of Florida code; permissive COLAMD licence.
      free

      # Files: SRC/include/wingetopt.*
      # Microsoft code; Obtained from https://github.com/iotivity/iotivity/tree/master/resource/c_common/windows.
      asl20
    ];
    description = "Library for the solution of large, sparse, nonsymmetric systems of linear equations";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
