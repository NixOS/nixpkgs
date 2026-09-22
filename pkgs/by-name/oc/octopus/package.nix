{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  ninja,
  gfortran,
  which,
  perl,
  procps,
  libvdwxc,
  libyaml,
  libxc,
  fftw,
  blas,
  lapack,
  gsl,
  netcdf,
  arpack,
  spglib,
  metis,
  scalapack,
  mpi,
  enableMpi ? true,
  config,
  cudaPackages,
  enableCuda ? config.cudaSupport,
  rocmPackages,
  enableHip ? config.rocmSupport,
  makeWrapper,
  addDriverRunpath,
  python3,
}:

assert (!blas.isILP64) && (!lapack.isILP64);
assert (blas.isILP64 == arpack.isILP64);
assert !(enableCuda && enableHip);

stdenv.mkDerivation (finalAttrs: {
  pname = "octopus";
  version = "16.4";

  src = fetchFromGitLab {
    owner = "octopus-code";
    repo = "octopus";
    tag = finalAttrs.version;
    hash = "sha256-XN9Smpmzu8KQpQ92TSCfK/tKMFpn5yj/B8wTzyF3GK0=";
  };

  outputs = [
    "out"
    "dev"
    "testsuite"
  ];

  patches = [
    ./hipblas-hipDoubleComplex.patch
    ./cuda-nvtx3.patch
    ./gfortran-15-c-loc.patch
  ];

  nativeBuildInputs = [
    which
    perl
    procps
    cmake
    gfortran
    pkg-config
    ninja
    makeWrapper
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
    addDriverRunpath
  ];

  buildInputs = [
    libyaml
    libxc
    blas
    lapack
    gsl
    fftw
    netcdf
    arpack
    libvdwxc
    spglib
    metis
    (python3.withPackages (ps: [ ps.pyyaml ]))
  ]
  ++ lib.optional enableMpi scalapack
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
    cudaPackages.libcufft
    cudaPackages.cuda_nvrtc
    cudaPackages.cuda_nvtx
  ]
  ++ lib.optionals enableHip [
    rocmPackages.clr
    rocmPackages.hipblas
    rocmPackages.hipfft
    rocmPackages.roctracer
  ];

  propagatedBuildInputs = lib.optional enableMpi mpi;
  propagatedUserEnvPkgs = lib.optional enableMpi mpi;

  cmakeFlags = [
    (lib.cmakeBool "OCTOPUS_MPI" enableMpi)
    (lib.cmakeBool "OCTOPUS_ScaLAPACK" enableMpi)
    (lib.cmakeBool "OCTOPUS_OpenMP" true)
    (lib.cmakeBool "OCTOPUS_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ]
  ++ lib.optional enableCuda (lib.cmakeBool "OCTOPUS_CUDA" true)
  ++ lib.optionals enableHip [
    (lib.cmakeBool "OCTOPUS_HIP" true)
    "-DHIP_ROOT_DIR=${rocmPackages.clr}"
    "-DCMAKE_MODULE_PATH=${rocmPackages.clr}/lib/cmake/hip"
  ]
  # gfortran >= 15 tightened ISO_C_BINDING argument checking; octopus passes
  # `c_loc()` results to by-reference `type(c_ptr)` dummies in several GPU
  # interop wrappers, which now errors. Relax it for GPU builds only.
  ++ lib.optional (enableCuda || enableHip) (
    lib.cmakeFeature "CMAKE_Fortran_FLAGS" "-fallow-argument-mismatch"
  );

  nativeCheckInputs = lib.optional enableMpi mpi;
  doCheck = false; # requires installed data

  postPatch = ''
    patchShebangs ./
  '';

  postConfigure = ''
    patchShebangs testsuite/oct-run_testsuite.sh
  '';

  postInstall = ''
    mkdir -p $testsuite
    moveToOutput share/octopus/testsuite $testsuite
  '';

  # Octopus JIT-compiles its GPU kernels at runtime via hiprtc, which
  # delegates to libamd_comgr for the actual compilation. comgr reads
  # only two environment variables: HIP_PATH (to find the device compiler
  # at $HIP_PATH/llvm/bin/clang) and HIP_DEVICE_LIB_PATH (to find the
  # device bitcode libraries). The clr setup-hook only exports these
  # during the build, so bake them into a wrapper for every installed
  # binary so GPU runs work out of the box.
  postFixup = lib.optionalString enableHip ''
    for bin in $out/bin/*; do
      if [ -f "$bin" ] && [ ! -L "$bin" ] && head -c 4 "$bin" | grep -qa 'ELF'; then
        wrapProgram "$bin" \
          --set HIP_PATH "${rocmPackages.clr}" \
          --set HIP_DEVICE_LIB_PATH "${rocmPackages.rocm-device-libs}/amdgcn/bitcode"
      fi
    done
  '';

  enableParallelBuilding = true;

  passthru = lib.attrsets.optionalAttrs enableMpi { inherit mpi; };

  meta = {
    description = "Real-space time dependent density-functional theory code";
    homepage = "https://octopus-code.org";
    maintainers = with lib.maintainers; [ markuskowa ];
    license = with lib.licenses; [
      gpl2Only
      asl20
      lgpl3Plus
      bsd3
    ];
    platforms = [ "x86_64-linux" ];
  };
})
