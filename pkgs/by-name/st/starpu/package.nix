{
  # derivation dependencies
  lib,
  fetchzip,
  stdenv,

  # starpu dependencies
  hwloc,
  libuuid,
  libX11,
  fftw,
  fftwFloat, # Same than previous but with float precision
  pkg-config,
  libtool,
  autoconf,
  automake,
  simgrid ? null, # Can be null because Simgrid is optional
  mpi ? null, # Can be null because MPI support is optional

  # Options
  enableSimgrid ? false,
  enableMPI ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "starpu";
  version = "1.4.7";

  inherit enableSimgrid;
  inherit enableMPI;

  src = fetchzip {
    url = "https://files.inria.fr/starpu/starpu-${finalAttrs.version}/starpu-${finalAttrs.version}.tar.gz";
    hash = "sha256-6AjQr+2nSJ/uYjJ6II4vJgxj5nHuvlsLvPGZZv/cU8M=";
  };

  # Runtime build dependencies
  nativeBuildInputs = [
    pkg-config
  ];

  # Those runtime dependencies will be propagated to environments importing this derivation
  propagatedNativeBuildInputs =
    [
      hwloc
    ]
    ++ lib.optional finalAttrs.enableSimgrid simgrid
    ++ lib.optional finalAttrs.enableMPI mpi;

  buildInputs = [
    libuuid
    libX11
    fftw
    fftwFloat
    pkg-config
    libtool
    autoconf
    automake
  ];

  # Those libraries dependencies will be propagated to environments importing this derivation
  propagatedBuildInputs =
    [
      hwloc
    ]
    ++ lib.optional finalAttrs.enableSimgrid simgrid
    ++ lib.optional finalAttrs.enableMPI mpi;

  configureFlags =
    [ ]
    ++ lib.optional finalAttrs.enableSimgrid "--enable-simgrid"
    ++ lib.optional finalAttrs.enableMPI [
      "--enable-mpi"
      "--enable-mpi-check"
      "--disable-shared"
    ]; # Last arg enables static linking which is mandatory for smpi

  # Some installation scripts use /bin/bash which isn't available in nix
  patches = [ ./nix-starpu-shebang.patch ];

  enableParallelBuilding = true;
  # doCheck = true;

  meta = {
    homepage = "https://starpu.gitlabpages.inria.fr/index.html";
    changelog = "https://files.inria.fr/starpu/starpu-${finalAttrs.version}/log.txt";
    description = "Task programming library for hybrid architectures";
    longDescription = ''
      StarPU is a task programming library for hybrid architectures

      - The application provides algorithms and constraints
        - CPU/GPU implementations of tasks
        - A graph of tasks, using either StarPU’s rich C/C++/Fortran/Python API, or OpenMP pragmas.
      - StarPU internally deals with the following aspects:
        - Task dependencies
        - Optimized heterogeneous scheduling
        - Optimized data transfers and replication between main memory and discrete memories
        - Optimized cluster communications
        - Fully asynchronous execution without spurious waits

      Rather than handling low-level issues, programmers can concentrate on algorithmic aspects!
    '';
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.PhoqueEberlue ];
  };
})
