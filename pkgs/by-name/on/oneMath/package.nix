{
  fetchFromGitHub,
  lib,
  intelLlvmStdenv,
  cmake,
  ninja,
  onetbb,
  opencl-headers,
  generic-sycl-components,
  config,
  symlinkJoin,
  cudaPackages ? { },
  rocmPackages ? { },
  autoAddDriverRunpath,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
  # Currently this package only allows building for one AMD arch.
  # gfx1030 is picked as arbitrary default, override this to your GPUs arch.
  rocmGpuTarget ? "gfx1030",
  cudaGpuArch ? "sm_60",
}:
let
  useGenericBlas = !cudaSupport && !rocmSupport;
  generic-blas = generic-sycl-components.override {
    # Since we only use this on Intel, only tune it for Intel
    gpuTuningTarget = "INTEL_GPU";
  };

  cudatoolkit_joined = symlinkJoin {
    name = "cuda-toolkit-joined";
    paths = with cudaPackages; [
      cuda_cudart
      cuda_nvcc
      libcublas
      libcublas.lib
      libcublas.include
      libcublas.stubs
      libcusolver
      libcusolver.lib
      libcusolver.include
      libcufft
      libcufft.lib
      libcufft.include
      libcurand
      libcurand.lib
      libcurand.include
      libcusparse
      libcusparse.lib
      libcusparse.include
    ];
    # Make stubs available at lib64 for FindCUDA
    postBuild = ''
      mkdir -p $out/lib64
      ln -s $out/lib/stubs/libcuda.so $out/lib64/libcuda.so
      ln -s $out/lib/stubs $out/lib64/stubs
    '';
  };
in
intelLlvmStdenv.mkDerivation (finalAttrs: {
  pname = "oneMath";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneMath";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jVcrpne6OyOeUlQHg07zZXEyFXvEGCYW88sWnYgEeu8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
  ];

  buildInputs = [
    onetbb
    opencl-headers
  ]
  ++ lib.optionals useGenericBlas [
    generic-blas
  ]
  ++ lib.optional cudaSupport cudatoolkit_joined
  ++ lib.optionals rocmSupport (
    with rocmPackages;
    [
      clr
      rocblas
      rocfft
      rocsolver
      rocrand
      # The nixpkgs version is too new for oneMath
      # TODO: Try reenabling this when oneMath updates
      # rocsparse
    ]
  );

  # Check the support matrix of CPU/GPU x Library x Compiler here:
  #   https://github.com/uxlfoundation/oneMath#linux
  cmakeFlags = [
    (lib.cmakeFeature "ONEMATH_SYCL_IMPLEMENTATION" "dpc++")

    # Requires closed-source icpx
    (lib.cmakeBool "ENABLE_MKLCPU_BACKEND" false)
    (lib.cmakeBool "ENABLE_MKLGPU_BACKEND" false)

    (lib.cmakeBool "ENABLE_NETLIB_BACKEND" false)

    (lib.cmakeBool "ENABLE_ARMPL_BACKEND" false)
    (lib.cmakeBool "ENABLE_ARMPL_OMP" true)
    (lib.cmakeBool "ENABLE_ARMPL_OPENRNG" false)

    (lib.cmakeBool "ENABLE_MKLCPU_THREAD_TBB" true)

    (lib.cmakeBool "ENABLE_GENERIC_BLAS_BACKEND" useGenericBlas)

    (lib.cmakeBool "ENABLE_PORTFFT_BACKEND" false)

    (lib.cmakeBool "BUILD_FUNCTIONAL_TESTS" false)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeBool "ENABLE_CUBLAS_BACKEND" true)
    (lib.cmakeBool "ENABLE_CUSOLVER_BACKEND" true)
    (lib.cmakeBool "ENABLE_CUFFT_BACKEND" true)
    (lib.cmakeBool "ENABLE_CURAND_BACKEND" true)
    (lib.cmakeBool "ENABLE_CUSPARSE_BACKEND" true)
    (lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${cudatoolkit_joined}")
    (lib.cmakeFeature "CUDA_CUDA_LIBRARY" "${cudaPackages.cuda_cudart}/lib/stubs/libcuda.so")
  ]
  ++ lib.optionals rocmSupport [
    (lib.cmakeBool "ENABLE_ROCBLAS_BACKEND" true)
    (lib.cmakeBool "ENABLE_ROCFFT_BACKEND" true)
    (lib.cmakeBool "ENABLE_ROCSOLVER_BACKEND" true)
    (lib.cmakeBool "ENABLE_ROCRAND_BACKEND" true)
    # The nixpkgs version is too new for oneMath
    # TODO: Try reenabling this when oneMath updates
    # (lib.cmakeBool "ENABLE_ROCSPARSE_BACKEND" true)

    # From the docs (https://uxlfoundation.github.io/oneMath/building_the_project_with_dpcpp.html):
    # > Currently, DPC++ can only build for a single HIP target at a time. This may change in future versions.
    # TODO: See if multiple targets work when building with adaptivecpp
    (lib.cmakeFeature "HIP_TARGETS" rocmGpuTarget)
  ];

  passthru = lib.optionalAttrs rocmSupport { inherit rocmGpuTarget; };

  meta = {
    changelog = "https://github.com/uxlfoundation/oneMath/releases/tag/v${finalAttrs.version}";
    description = "Unified Math Library for accelerated computing using SYCL";
    longDescription = "oneMath is an open-source implementation of the [oneMath specification](https://oneapi-spec.uxlfoundation.org/specifications/oneapi/latest/elements/onemath/source/) that can work with multiple devices using multiple libraries (backends) underneath.";
    homepage = "https://github.com/uxlfoundation/oneMath";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kilyanni ];
    platforms = lib.platforms.linux;
  };
})
