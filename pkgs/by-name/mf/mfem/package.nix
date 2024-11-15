{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  mpi,
  mpiCheckPhaseHook,
  blas,
  hypre,
  metis,
  suitesparse,
  mumps_par,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mfem";
  version = "4.7";

  src = fetchFromGitHub {
    owner = "mfem";
    repo = "mfem";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NJI8ABsfnnzMETfyscpNX8qK72BFF9FfxsY0J48aRtg=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [
    mpi
    blas
    hypre
    metis
    suitesparse
    mumps_par
  ];

  cmakeFlags = [
    (lib.cmakeBool "MFEM_ENABLE_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "MFEM_USE_MPI" true)
    (lib.cmakeBool "MFEM_USE_SUITESPARSE" true)
    (lib.cmakeBool "MFEM_USE_MUMPS" true)
    (lib.cmakeFeature "MUMPS_REQUIRED_PACKAGES" (
      lib.concatStringsSep ";" (
        [
          "MPI"
          "MPI_Fortran"
          "METIS"
          "ScaLAPACK"
          "LAPACK"
          "BLAS"
        ]
        ++ lib.optional mumps_par.withParmetis "ParMETIS"
      )
    ))
  ];

  doCheck = true;

  nativeCheckInputs = [ mpiCheckPhaseHook ];

  meta = {
    description = "Free, lightweight, scalable C++ library for finite element methods";
    homepage = "https://mfem.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ qbisi ];
    platforms = lib.platforms.linux;
  };
})
