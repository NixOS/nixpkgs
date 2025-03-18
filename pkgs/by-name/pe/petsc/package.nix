{
  lib,
  stdenv,
  fetchzip,
  cctools,
  gfortran,
  python3,
  blas,
  lapack,
  mpiSupport ? true,
  mpi, # generic mpi dependency
  openssh, # required for openmpi tests
  petsc-withp4est ? false,
  hdf5-support ? false,
  hdf5,
  metis,
  parmetis,
  pkg-config,
  p4est,
  zlib, # propagated by p4est but required by petsc
  petsc-optimized ? false,
  petsc-scalar-type ? "real",
  petsc-precision ? "double",
}:

# This version of PETSc does not support a non-MPI p4est build
assert petsc-withp4est -> p4est.mpiSupport;

stdenv.mkDerivation rec {
  pname = "petsc";
  version = "3.21.3";

  src = fetchzip {
    url = "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-${version}.tar.gz";
    hash = "sha256-dxHa8JUJCN4zRIXMCx7gcvbzFH2SPtkJ377ssIevjgU=";
  };

  inherit mpiSupport;
  withp4est = petsc-withp4est;

  strictDeps = true;
  nativeBuildInputs = [
    python3
    gfortran
    pkg-config
  ] ++ lib.optional mpiSupport mpi ++ lib.optional (mpiSupport && mpi.pname == "openmpi") openssh;
  buildInputs = [
    blas
    lapack
  ] ++ lib.optional hdf5-support hdf5 ++ lib.optional withp4est p4est;

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace config/install.py \
      --replace /usr/bin/install_name_tool ${cctools}/bin/install_name_tool
  '';

  # Both OpenMPI and MPICH get confused by the sandbox environment and spew errors like this (both to stdout and stderr):
  #     [hwloc/linux] failed to find sysfs cpu topology directory, aborting linux discovery.
  #     [1684747490.391106] [localhost:14258:0]       tcp_iface.c:837  UCX  ERROR opendir(/sys/class/net) failed: No such file or directory
  # These messages contaminate test output, which makes the quicktest suite to fail. The patch adds filtering for these messages.
  patches = [ ./filter_mpi_warnings.patch ];

  preConfigure = ''
    patchShebangs ./lib/petsc/bin
    configureFlagsArray=(
      $configureFlagsArray
      ${
        if !mpiSupport then
          ''
            "--with-mpi=0"
          ''
        else
          ''
            "--CC=mpicc"
            "--with-cxx=mpicxx"
            "--with-fc=mpif90"
            "--with-mpi=1"
            "--with-metis=1"
            "--with-metis-dir=${metis}"
            "--with-parmetis=1"
            "--with-parmetis-dir=${parmetis}"
          ''
      }
      ${lib.optionalString withp4est ''
        "--with-p4est=1"
        "--with-zlib-include=${zlib.dev}/include"
        "--with-zlib-lib=-L${zlib}/lib -lz"
      ''}
      ${lib.optionalString hdf5-support ''
        "--with-hdf5=1"
        "--with-hdf5-fortran-bindings=1"
        "--with-hdf5-lib=-L${hdf5}/lib -lhdf5"
        "--with-hdf5-include=${hdf5.dev}/include"
      ''}
      "--with-blas=1"
      "--with-lapack=1"
      "--with-scalar-type=${petsc-scalar-type}"
      "--with-precision=${petsc-precision}"
      ${lib.optionalString petsc-optimized ''
        "--with-debugging=0"
        COPTFLAGS='-O3'
        FOPTFLAGS='-O3'
        CXXOPTFLAGS='-O3'
        CXXFLAGS='-O3'
      ''}
    )
  '';

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

  meta = with lib; {
    description = "Portable Extensible Toolkit for Scientific computation";
    homepage = "https://petsc.org/release/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cburstedde ];
  };
}
