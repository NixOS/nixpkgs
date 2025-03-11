{
  stdenv,
  lib,
  fetchFromBitbucket,
  fetchzip,
  gfortran,
  mpi,
  petsc,
  blas,
  lapack,
  parmetis,
  hdf5-fortran-mpi,
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
    # upstream petsc has lots of fortran api change since 3.22.*
    # will keep using old petsc-3.21.4 until pflotran support latest petsc
    (petsc.overrideAttrs rec {
      version = "3.21.4";
      src = fetchzip {
        url = "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-${version}.tar.gz";
        hash = "sha256-l7v+ASBL9FLbBmBGTRWDwBihjwLe3uLz+GwXtn8u7e0=";
      };
    })
    blas
    lapack
    hdf5-fortran-mpi
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
      --subst-var-by "HDF5_FORTRAN_LIBS" "${lib.getLib hdf5-fortran-mpi}/lib" \
      --subst-var-by "HDF5_FORTRAN_INCLUDE" "${lib.getDev hdf5-fortran-mpi}/include"
  '';

  meta = with lib; {
    description = "Parallel, multi-physics simulation code for subsurface flow and transport";
    homepage = "https://pflotran.org/";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
})
