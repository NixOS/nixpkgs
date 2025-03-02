{
  stdenv,
  lib,
  fetchFromBitbucket,
  gfortran,
  mpi,
  petsc,
  blas,
  lapack,
  parmetis,
  hdf5,
  mpiCheckPhaseHook,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "PFLOTRAN";
  version = "6.0.1";

  src = fetchFromBitbucket {
    owner = "pflotran";
    repo = "pflotran";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AZXzay6GWbnxONB8Slg8gV0KN1CxGCXbJ45ZeWL1034=";
  };

  patches = [ ./make.patch ];

  nativeBuildInputs = [ gfortran ];

  buildInputs = [
    petsc
    blas
    lapack
    hdf5
    parmetis
  ];

  propagatedBuildInputs = [ mpi ];
  propagatedUserEnvPkgs = [ mpi ];
  passthru = { inherit mpi; };

  enableParallelBuilding = true;

  /*
    Pflotran does not use a "real" autotools configure script, but a simple bash
    script, that is merely named configure. Consequently, many common mechanism
    don't work. Thus, we need to help make to figure out some include and library
    paths.
  */
  preConfigure = ''
    substituteInPlace src/pflotran/makefile \
      --subst-var-by "HDF5_FORTRAN_LIBS" "${lib.getLib hdf5}/lib" \
      --subst-var-by "HDF5_FORTRAN_INCLUDE" "${lib.getDev hdf5}/include"
  '';

  configureFlags = [
    "--with-petsc-dir=${petsc}"
    "--with-petsc-arch=linux-gnu-c-release"
  ];

  meta = with lib; {
    description = "Parallel, multi-physics simulation code for subsurface flow and transport";
    homepage = "https://pflotran.org/";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
})
