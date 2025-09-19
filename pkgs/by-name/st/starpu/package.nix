{
  # derivation dependencies
  lib,
  fetchurl,
  stdenv,
  writableTmpDirAsHomeHook,
  autoreconfHook,

  # starpu dependencies
  hwloc,
  libuuid,
  libX11,
  fftw,
  fftwFloat, # Same than previous but with float precision
  pkg-config,
  libtool,
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

  nativeBuildInputs =
    [
      pkg-config
      hwloc
      libtool
      writableTmpDirAsHomeHook
      autoreconfHook
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

  configureFlags = [
    (lib.enableFeature true "quick-check")
    (lib.enableFeature false "build-examples")
    (lib.enableFeature finalAttrs.enableSimgrid "simgrid")
    (lib.enableFeature finalAttrs.enableMPI "mpi")
    (lib.enableFeature finalAttrs.enableMPI "mpi-check")
    (lib.enableFeature (!finalAttrs.enableMPI) "shared") # Static linking is mandatory for smpi
    (lib.optional stdenv.hostPlatform.isDarwin (lib.enableFeature true "maxcpus=4"))
  ];
  # No need to add flags for CUDA, it should be detected by ./configure

  postConfigure = ''
    # Patch shebangs recursively because a lot of scripts are used
    shopt -s globstar
    patchShebangs --build **/*.sh
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
