{
  lib,
  stdenv,
  fetchzip,
  cctools,
  gfortran,
  replaceVars,
  python3,
  python3Packages,
  blas,
  lapack,
  zlib, # propagated by p4est but required by petsc
  mpi, # generic mpi dependency
  mpiCheckPhaseHook,

  # Build options
  petsc-optimized ? true,
  petsc-scalar-type ? "real",
  petsc-precision ? "double",
  mpiSupport ? true,
  withPetsc4py ? false, # petsc python binding
  withFullDeps ? false, # full External libraries support

  # External libraries options
  withHdf5 ? true,
  withMetis ? withFullDeps,
  withParmetis ? false, # parmetis is unfree and should be enabled manualy
  withPtscotch ? withFullDeps,
  withScalapack ? withFullDeps,
  withMumps ? withFullDeps,
  withP4est ? withFullDeps,

  # External libraries
  hdf5-fortran-mpi,
  metis,
  parmetis,
  scotch,
  scalapack,
  mumps_par,
  pkg-config,
  p4est,
}:

# This version of PETSc does not support a non-MPI p4est build
assert withP4est -> (p4est.mpiSupport && mpiSupport);

# Package parmetis depend on metis and mpi support
assert withParmetis -> (withMetis && mpiSupport);

assert withPtscotch -> mpiSupport;
assert withScalapack -> mpiSupport;
assert withMumps -> withScalapack;

stdenv.mkDerivation rec {
  pname = "petsc";
  version = "3.21.4";

  src = fetchzip {
    url = "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-${version}.tar.gz";
    hash = "sha256-l7v+ASBL9FLbBmBGTRWDwBihjwLe3uLz+GwXtn8u7e0=";
  };

  strictDeps = true;

  nativeBuildInputs =
    [
      python3
      gfortran
      pkg-config
    ]
    ++ lib.optional mpiSupport mpi
    ++ lib.optionals withPetsc4py [
      python3Packages.setuptools
      python3Packages.cython
    ];

  buildInputs =
    [
      blas
      lapack
    ]
    ++ lib.optional withHdf5 hdf5-fortran-mpi
    ++ lib.optional withP4est p4est
    ++ lib.optional withMetis metis
    ++ lib.optional withParmetis parmetis
    ++ lib.optional withPtscotch scotch
    ++ lib.optional withScalapack scalapack
    ++ lib.optional withMumps mumps_par;

  propagatedBuildInputs = lib.optional withPetsc4py python3Packages.numpy;

  patches = [
    (replaceVars ./fix-petsc4py-install-prefix.patch {
      PYTHON_SITEPACKAGES = python3.sitePackages;
    })
  ];

  postPatch =
    ''
      patchShebangs ./lib/petsc/bin
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace config/install.py \
        --replace /usr/bin/install_name_tool ${cctools}/bin/install_name_tool
    '';

  configureFlags =
    [
      "--with-blas=1"
      "--with-lapack=1"
      "--with-scalar-type=${petsc-scalar-type}"
      "--with-precision=${petsc-precision}"
      "--with-mpi=${if mpiSupport then "1" else "0"}"
    ]
    ++ lib.optional withPetsc4py "--with-petsc4py=1"
    ++ lib.optionals mpiSupport [
      "--CC=mpicc"
      "--with-cxx=mpicxx"
      "--with-fc=mpif90"
    ]
    ++ lib.optionals withMetis [
      "--with-metis=1"
      "--with-metis-dir=${metis}"
    ]
    ++ lib.optionals withParmetis [
      "--with-parmetis=1"
      "--with-parmetis-dir=${parmetis}"
    ]
    ++ lib.optionals withPtscotch [
      "--with-ptscotch=1"
      "--with-ptscotch-include=${lib.getDev scotch}/include"
      "--with-ptscotch-lib=[-L${lib.getLib scotch}/lib,-lptscotch,-lptesmumps,-lptscotchparmetisv3,-lptscotcherr,-lesmumps,-lscotch,-lscotcherr]"
    ]
    ++ lib.optionals withScalapack [
      "--with-scalapack=1"
      "--with-scalapack-dir=${scalapack}"
    ]
    ++ lib.optionals withMumps [
      "--with-mumps=1"
      "--with-mumps-dir=${mumps_par}"
    ]
    ++ lib.optionals withP4est [
      "--with-p4est=1"
      "--with-zlib-include=${lib.getDev zlib}/include"
      "--with-zlib-lib=[-L${lib.getLib zlib}/lib,-lz]"
    ]
    ++ lib.optionals withHdf5 [
      "--with-hdf5=1"
      "--with-hdf5-fortran-bindings=1"
      "--with-hdf5-include=${lib.getDev hdf5-fortran-mpi}/include"
      "--with-hdf5-lib=[-L${lib.getLib hdf5-fortran-mpi}/lib,-lhdf5]"
    ]
    ++ lib.optionals petsc-optimized [
      "--with-debugging=0"
      "COPTFLAGS=-O3"
      "FOPTFLAGS=-O3"
      "CXXOPTFLAGS=-O3"
      "CXXFLAGS=-O3"
    ];

  hardeningDisable = lib.optionals (!petsc-optimized) [
    "fortify"
    "fortify3"
  ];

  configureScript = "python ./configure";

  enableParallelBuilding = true;

  # This is needed as the checks need to compile and link the test cases with
  # -lpetsc, which is not available in the checkPhase, which is executed before
  # the installPhase. The installCheckPhase comes after the installPhase, so
  # the library is installed and available.
  doInstallCheck = true;
  installCheckTarget = "check_install";
  nativeInstallCheckInputs = [ mpiCheckPhaseHook ];

  passthru = {
    inherit mpiSupport;
  };

  meta = with lib; {
    description = "Portable Extensible Toolkit for Scientific computation";
    homepage = "https://petsc.org/release/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cburstedde ];
  };
}
