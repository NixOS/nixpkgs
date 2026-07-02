{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  fftwSinglePrec,
  doxygen,
  swig,
  graphviz,
  enablePython ? false,
  python3Packages,
  enableOpencl ? true,
  opencl-headers,
  ocl-icd,
  config,
  enableCuda ? config.cudaSupport,
  cudaPackages,
  autoAddDriverRunpath,

  # passthru
  nix-update-script,
}:

let
  effectiveStdenv = if enableCuda then cudaPackages.backendStdenv else stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "openmm";
  version = "8.5.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "openmm";
    repo = "openmm";
    tag = finalAttrs.version;
    hash = "sha256-9mOgnMgRU7zE9UWJ03VNoOTt76nPTHXZ4xkSKtOTwng=";
  };

  # "This test is stochastic and may occasionally fail". It does.
  postPatch = ''
    rm \
      platforms/*/tests/Test*BrownianIntegrator.* \
      platforms/*/tests/Test*LangevinIntegrator.* \
      serialization/tests/TestSerializeIntegrator.cpp
  '';

  nativeBuildInputs = [
    cmake
    gfortran
    swig
    doxygen
    graphviz # doxygen missing components: dot
    python3Packages.python
  ]
  ++ lib.optionals enablePython [
    python3Packages.build
    python3Packages.installer
    python3Packages.wheel
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];

  buildInputs = [
    fftwSinglePrec
  ]
  ++ lib.optionals enableOpencl [
    ocl-icd
    opencl-headers
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_cudart # CUDA::cuda_driver (driver stub)
    cudaPackages.cuda_nvrtc # runtime kernel compilation
    cudaPackages.cuda_profiler_api # cudaProfiler.h
    cudaPackages.libcufft # CUDA::cufft
  ];

  propagatedBuildInputs = lib.optionals enablePython (
    with python3Packages;
    [
      setuptools
      python
      numpy
      cython
    ]
  );

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" true)
    (lib.cmakeBool "OPENMM_BUILD_AMOEBA_PLUGIN" true)
    (lib.cmakeBool "OPENMM_BUILD_CPU_LIB" true)
    (lib.cmakeBool "OPENMM_BUILD_C_AND_FORTRAN_WRAPPERS" true)
    (lib.cmakeBool "OPENMM_BUILD_DRUDE_PLUGIN" true)
    (lib.cmakeBool "OPENMM_BUILD_PME_PLUGIN" true)
    (lib.cmakeBool "OPENMM_BUILD_RPMD_PLUGIN" true)
    (lib.cmakeBool "OPENMM_BUILD_SHARED_LIB" true)
  ]
  ++ lib.optionals enablePython [
    (lib.cmakeBool "OPENMM_BUILD_PYTHON_WRAPPERS" true)
  ]
  ++ lib.optionals enableOpencl [
    (lib.cmakeBool "OPENMM_BUILD_AMOEBA_OPENCL_LIB" true)
    (lib.cmakeBool "OPENMM_BUILD_DRUDE_OPENCL_LIB" true)
    (lib.cmakeBool "OPENMM_BUILD_OPENCL_LIB" true)
    (lib.cmakeBool "OPENMM_BUILD_RPMD_OPENCL_LIB" true)
  ]
  ++ lib.optionals enableCuda [
    (lib.cmakeBool "OPENMM_BUILD_AMOEBA_CUDA_LIB" true)
    (lib.cmakeBool "OPENMM_BUILD_CUDA_LIB" true)
    (lib.cmakeBool "OPENMM_BUILD_DRUDE_CUDA_LIB" true)
    (lib.cmakeBool "OPENMM_BUILD_RPMD_CUDA_LIB" true)
  ];

  postInstall = lib.strings.optionalString enablePython ''
    export OPENMM_LIB_PATH=$out/lib
    export OPENMM_INCLUDE_PATH=$out/include
    cd python
    ${python3Packages.python.pythonOnBuildForHost.interpreter} -m build --no-isolation --outdir dist/ --wheel
    ${python3Packages.python.pythonOnBuildForHost.interpreter} -m installer --prefix $out dist/*.whl
  '';

  # Couldn't get CUDA to run properly in the sandbox
  doCheck = !enableCuda && !enableOpencl;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Toolkit for molecular simulation using high performance GPU code";
    mainProgram = "TestReferenceHarmonicBondForce";
    homepage = "https://openmm.org/";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
