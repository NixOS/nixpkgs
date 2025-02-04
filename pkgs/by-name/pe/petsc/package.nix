{
  lib,
  stdenv,
  fetchzip,
  cctools,
  gfortran,
  python3,
  withPetsc4py ? false,
  blas,
  lapack,
  mpiSupport ? true,
  mpi, # generic mpi dependency
  mpiCheckPhaseHook,
  petsc-withp4est ? false,
  hdf5-support ? false,
  hdf5,
  metis,
  withMetis ? false,
  parmetis,
  withParmetis ? false,
  scotch,
  withPtscotch ? false,
  pkg-config,
  p4est,
  zlib, # propagated by p4est but required by petsc
  petsc-optimized ? false,
  petsc-scalar-type ? "real",
  petsc-precision ? "double",
}:

# This version of PETSc does not support a non-MPI p4est build
assert petsc-withp4est -> p4est.mpiSupport;

# Package parmetis depend on metis and mpi support
assert withParmetis -> (withMetis && mpiSupport);

assert withPtscotch -> mpiSupport;

stdenv.mkDerivation rec {
  pname = "petsc";
  version = "3.22.3";

  src = fetchzip {
    url = "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-${version}.tar.gz";
    hash = "sha256-MPcOdHp5rMhIA9Yw/btOLcwYn4CpNZkRgPb5nh+9wko=";
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
      python3.pkgs.setuptools
      python3.pkgs.cython
    ];

  buildInputs =
    [
      blas
      lapack
    ]
    ++ lib.optional hdf5-support hdf5
    ++ lib.optional petsc-withp4est p4est
    ++ lib.optional withMetis metis
    ++ lib.optional withParmetis parmetis
    ++ lib.optional withPtscotch scotch;

  propagatedBuildInputs = lib.optional withPetsc4py python3.pkgs.numpy;

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
      "--with-ptscotch-include=${scotch.dev}/include"
      "--with-ptscotch-lib=[-L${scotch}/lib,-lptscotch,-lptesmumps,-lptscotchparmetisv3,-lptscotcherr,-lesmumps,-lscotch,-lscotcherr]"
    ]
    ++ lib.optionals petsc-withp4est [
      "--with-p4est=1"
      "--with-zlib-include=${zlib.dev}/include"
      "--with-zlib-lib=[-L${zlib}/lib,-lz]"
    ]
    ++ lib.optionals hdf5-support [
      "--with-hdf5=1"
      "--with-hdf5-fortran-bindings=1"
      "--with-hdf5-include=${hdf5.dev}/include"
      "--with-hdf5-lib=[-L${hdf5}/lib,-lhdf5]"
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
