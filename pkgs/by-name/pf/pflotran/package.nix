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
  python312Packages,
}:

let
  /*
    Upstream petsc has lots of fortran api change since 3.22.0
    We will keep using older version until pflotran supports the latest petsc.
    Pflotran also requires Parmetis support in Petsc to have actual parmetis support.
  */
  petsc' =
    (petsc.overrideAttrs rec {
      version = "3.21.4";
      src = fetchzip {
        url = "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-${version}.tar.gz";
        hash = "sha256-l7v+ASBL9FLbBmBGTRWDwBihjwLe3uLz+GwXtn8u7e0=";
      };
    }).override
      {
        withMetis = true;
        withParmetis = true;
        python3Packages = python312Packages;
      };
in
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
    petsc'
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
