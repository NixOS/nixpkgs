{
  lib,
  stdenv,
  fetchzip,
  gfortran,
  replaceVars,
  python3,
  python3Packages,
  blas,
  lapack,
  zlib, # propagated by p4est but required by petsc
  mpi, # generic mpi dependency
  mpiCheckPhaseHook,
  bash,

  # Build options
  petsc-optimized ? true,
  petsc-scalar-type ? "real",
  petsc-precision ? "double",
  mpiSupport ? true,
  pythonSupport ? false, # petsc python binding
  withExamples ? false,
  withFullDeps ? false, # full External libraries support
  withCommonDeps ? true, # common External libraries support

  # External libraries options
  withHdf5 ? withCommonDeps,
  withMetis ? withCommonDeps,
  withScalapack ? withFullDeps,
  withParmetis ? withFullDeps, # parmetis is unfree
  withPtscotch ? withFullDeps,
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
assert withFullDeps -> withCommonDeps;

# This version of PETSc does not support a non-MPI p4est build
assert withP4est -> (p4est.mpiSupport && mpiSupport);

# Package parmetis depend on metis and mpi support
assert withParmetis -> (withMetis && mpiSupport);

assert withPtscotch -> mpiSupport;
assert withScalapack -> mpiSupport;
assert withMumps -> withScalapack;

stdenv.mkDerivation rec {
  pname = "petsc";
  version = "3.22.4";

  src = fetchzip {
    url = "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-${version}.tar.gz";
    hash = "sha256-8WV1ylXytkhiNa7YpWSOIpSvzLCCjdVVe5SiGfhicas=";
  };

  strictDeps = true;

  nativeBuildInputs =
    [
      python3
      gfortran
      pkg-config
    ]
    ++ lib.optional mpiSupport mpi
    ++ lib.optionals pythonSupport [
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

  propagatedBuildInputs = lib.optional pythonSupport python3Packages.numpy;

  patches = [
    (replaceVars ./fix-petsc4py-install-prefix.patch {
      PYTHON_SITEPACKAGES = python3.sitePackages;
    })
  ];

  postPatch = ''
    patchShebangs ./lib/petsc/bin

    substituteInPlace config/example_template.py \
      --replace-fail "/usr/bin/env bash" "${bash}/bin/bash"
  '';

  configureFlags =
    [
      "--with-blas=1"
      "--with-lapack=1"
      "--with-scalar-type=${petsc-scalar-type}"
      "--with-precision=${petsc-precision}"
      "--with-mpi=${if mpiSupport then "1" else "0"}"
    ]
    ++ lib.optional pythonSupport "--with-petsc4py=1"
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

  installTargets = [ (if withExamples then "install" else "install-lib") ];

  enableParallelBuilding = true;

  # This is needed as the checks need to compile and link the test cases with
  # -lpetsc, which is not available in the checkPhase, which is executed before
  # the installPhase. The installCheckPhase comes after the installPhase, so
  # the library is installed and available.
  doInstallCheck = true;
  installCheckTarget = "check_install";

  # The PETSC4PY=no flag disables the ex100 test,
  # which compiles C code to load Python modules for solving a math problem.
  # This test fails on the Darwin platform but is rarely a common use case for petsc4py.
  installCheckFlags = lib.optional stdenv.hostPlatform.isDarwin "PETSC4PY=no";

  nativeInstallCheckInputs =
    [
      mpiCheckPhaseHook
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.pythonImportsCheckHook
      python3Packages.unittestCheckHook
    ];

  unittestFlagsArray = [
    "-s"
    "src/binding/petsc4py/test"
    "-v"
  ];

  pythonImportsCheck = [ "petsc4py" ];

  passthru = {
    inherit mpiSupport pythonSupport;
  };

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Portable Extensible Toolkit for Scientific computation";
    homepage = "https://petsc.org/release/";
    license = licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [
      cburstedde
      qbisi
    ];
  };
}
