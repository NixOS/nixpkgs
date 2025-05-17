{
  # derivation dependencies
  lib,
  fetchurl,
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
  simgrid,
  mpi,
  cudaPackages,

  # Options
  enableSimgrid ? false,
  enableMPI ? false,
  enableCUDA ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "starpu";
  version = "1.4.7";

  inherit enableSimgrid;
  inherit enableMPI;
  inherit enableCUDA;

  src = fetchurl {
    url = "https://files.inria.fr/starpu/starpu-${finalAttrs.version}/starpu-${finalAttrs.version}.tar.gz";
    hash = "sha256-HrPfVRCJFT/m4LFyrZURhDS0qB6p6qWiw4cl0NtTsT4=";
  };

  # Runtime build dependencies
  nativeBuildInputs =
    [
      pkg-config
      hwloc
      libtool
      autoconf
      automake
    ]
    ++ lib.optional finalAttrs.enableSimgrid simgrid
    ++ lib.optional finalAttrs.enableMPI mpi
    ++ lib.optional finalAttrs.enableCUDA cudaPackages.cudatoolkit;

  buildInputs =
    [
      libuuid
      libX11
      fftw
      fftwFloat
      hwloc
    ]
    ++ lib.optional finalAttrs.enableSimgrid simgrid
    ++ lib.optional finalAttrs.enableMPI mpi
    ++ lib.optional finalAttrs.enableCUDA cudaPackages.cudatoolkit;

  configureFlags =
    [
      "--enable-quick-check"
      "--disable-build-examples"
    ]
    ++ lib.optional finalAttrs.enableSimgrid "--enable-simgrid"
    ++ lib.optional finalAttrs.enableMPI [
      "--enable-mpi"
      "--enable-mpi-check"
      "--disable-shared" # Static linking is mandatory for smpi
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [
      "--enable-maxcpus=4"
      "--disable-opencl"
    ];
  # No need to add flags for CUDA, it should be detected by ./configure

  preConfigure = ''
    ./autogen.sh
  '';

  postConfigure = ''
    # Patch shebangs recursively because a lot of scripts are used
    shopt -s globstar
    patchShebangs --build **/*.sh

    # this line removes a bug where value of $HOME is set to a non-writable /homeless-shelter dir
    export HOME=$(pwd)
  '';

  enableParallelBuilding = true;
  doCheck = true;

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
