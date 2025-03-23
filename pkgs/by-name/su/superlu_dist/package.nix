{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  blas,
  lapack,
  mpi,
  mpiCheckPhaseHook,
  metis,
  parmetis,

  # Todo: ask for permission of unfree parmetis
  withParmetis ? false,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation (finalAttrs: {
  pname = "superlu_dist";
  version = "9.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xiaoyeli";
    repo = "superlu_dist";
    tag = "v${finalAttrs.version}";
    # Remove non‐free files.
    postFetch = "rm $out/SRC/prec-independent/mc64ad_dist.c";
    hash = "sha256-NMAEtTmTY189p8BlmsTugwMuxKZh+Bs1GyuwUHkLA1U=";
  };

  patches = [
    ./mc64ad_dist-stub.patch
  ];

  postPatch = ''
    substituteInPlace SRC/prec-independent/util.c \
      --replace-fail "LargeDiag_MC64" "NOROWPERM"
  '';

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs =
    [
      mpi
      lapack
    ]
    ++ lib.optionals withParmetis [
      metis
      parmetis
    ];

  propagatedBuildInputs = [ blas ];

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
      (lib.cmakeBool "enable_fortran" true)
      (lib.cmakeBool "enable_complex16" true)
      (lib.cmakeBool "TPL_ENABLE_INTERNAL_BLASLIB" false)
      (lib.cmakeBool "TPL_ENABLE_LAPACKLIB" true)
      (lib.cmakeBool "TPL_ENABLE_PARMETISLIB" withParmetis)
    ]
    ++ lib.optionals withParmetis [
      (lib.cmakeFeature "TPL_PARMETIS_LIBRARIES" "-lmetis -lparmetis")
      (lib.cmakeFeature "TPL_PARMETIS_INCLUDE_DIRS" "${lib.getDev parmetis}/include")
    ];

  doCheck = true;

  nativeCheckInputs = [ mpiCheckPhaseHook ];

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
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
