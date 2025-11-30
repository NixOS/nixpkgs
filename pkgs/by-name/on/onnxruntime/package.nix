{
  config,
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  abseil-cpp_202407,
  cmake,
  cpuinfo,
  eigen,
  flatbuffers_23,
  glibcLocales,
  gtest,
  howard-hinnant-date,
  libpng,
  nlohmann_json,
  perl,
  pkg-config,
  python3Packages,
  removeReferencesTo,
  re2,
  zlib,
  protobuf,
  microsoft-gsl,
  darwinMinVersionHook,
  pythonSupport ? true,
  cudaSupport ? config.cudaSupport,
  ncclSupport ? cudaSupport && cudaPackages.nccl.meta.available,
  rocmSupport ? config.rocmSupport,
  withFullProtobuf ? false,
  cudaPackages ? { },
  rocmPackages,
}@inputs:

let
  version = "1.22.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-X8Pdtc0eR0iU+Xi2A1HrNo1xqCnoaxNjj4QFm/E3kSE=";
  };

  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv;
  inherit (cudaPackages) cuda_nvcc;

  cudaArchitecturesString = cudaPackages.flags.cmakeCudaArchitecturesString;

  mp11 = fetchFromGitHub {
    owner = "boostorg";
    repo = "mp11";
    tag = "boost-1.82.0";
    hash = "sha256-cLPvjkf2Au+B19PJNrUkTW/VPxybi1MpPxnIl4oo4/o=";
  };

  safeint = fetchFromGitHub {
    owner = "dcleblanc";
    repo = "safeint";
    tag = "3.0.28";
    hash = "sha256-pjwjrqq6dfiVsXIhbBtbolhiysiFlFTnx5XcX77f+C0=";
  };

  onnx = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    tag = "v1.17.0";
    hash = "sha256-9oORW0YlQ6SphqfbjcYb0dTlHc+1gzy9quH/Lj6By8Q=";
  };

  cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v3.5.1";
    hash = "sha256-sTGYN+bjtEqQ7Ootr/wvx3P9f8MCDSSj3qyCWjfdLEA=";
  };

  dlpack = fetchFromGitHub {
    owner = "dmlc";
    repo = "dlpack";
    rev = "5c210da409e7f1e51ddf445134a4376fdbd70d7d";
    hash = "sha256-YqgzCyNywixebpHGx16tUuczmFS5pjCz5WjR89mv9eI=";
  };

  isCudaJetson = cudaSupport && cudaPackages.flags.isJetsonBuild;
in
effectiveStdenv.mkDerivation rec {
  pname = "onnxruntime";
  inherit src version;

  patches = [
    # https://github.com/microsoft/onnxruntime/pull/24583
    (fetchpatch {
      name = "fix-compilation-with-gcc-15.patch";
      url = "https://github.com/microsoft/onnxruntime/commit/f7619dc93f592ddfc10f12f7145f9781299163a0.patch";
      hash = "sha256-jxfMB+/Zokcu5DSfZP7QV1E8mTrsLe/sMr+ZCX/Y3m0=";
    })
    # Handle missing default logger when cpuinfo initialization fails in the build sandbox
    # TODO: Remove on next release
    # https://github.com/microsoft/onnxruntime/issues/10038
    # https://github.com/microsoft/onnxruntime/pull/15661
    # https://github.com/microsoft/onnxruntime/pull/20509
    ./cpuinfo-logging.patch
  ]
  ++ lib.optionals cudaSupport [
    # We apply the referenced 1064.patch ourselves to our nix dependency.
    #  FIND_PACKAGE_ARGS for CUDA was added in https://github.com/microsoft/onnxruntime/commit/87744e5 so it might be possible to delete this patch after upgrading to 1.17.0
    ./nvcc-gsl.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
    protobuf
  ]
  ++ lib.optionals pythonSupport (
    with python3Packages;
    [
      pip
      python
      pythonOutputDistHook
      setuptools
      wheel
    ]
  )
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    removeReferencesTo
  ]
  ++ lib.optionals isCudaJetson [
    cudaPackages.autoAddCudaCompatRunpath
  ]
  ++ lib.optionals rocmSupport [
    perl # for tools/ci_build/hipify-perl
  ];

  buildInputs = [
    eigen
    glibcLocales
    howard-hinnant-date
    libpng
    nlohmann_json
    microsoft-gsl
    zlib
  ]
  ++ lib.optionals (lib.meta.availableOn effectiveStdenv.hostPlatform cpuinfo) [
    cpuinfo
  ]
  ++ lib.optionals pythonSupport (
    with python3Packages;
    [
      numpy
      pybind11
      packaging
    ]
  )
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cccl # cub/cub.cuh
      libcublas # cublas_v2.h
      libcurand # curand.h
      libcusparse # cusparse.h
      libcufft # cufft.h
      cudnn # cudnn.h
      cudnn-frontend
      cuda_cudart
    ]
    ++ lib.optionals ncclSupport [ nccl ]
  )
  ++ lib.optionals rocmSupport [
    rocmPackages.clr
    rocmPackages.hipblas
    rocmPackages.hipcub
    rocmPackages.hipfft
    rocmPackages.hiprand
    rocmPackages.hipsparse
    rocmPackages.rocblas
    rocmPackages.rocprim
    rocmPackages.rocrand
    rocmPackages.rocthrust
    rocmPackages.miopen
    rocmPackages.rccl
    rocmPackages.rocm-smi
    rocmPackages.roctracer
  ]
  ++ lib.optionals effectiveStdenv.hostPlatform.isDarwin [
    (darwinMinVersionHook "13.3")
  ];

  nativeCheckInputs = [
    gtest
  ]
  ++ lib.optionals pythonSupport (
    with python3Packages;
    [
      pytest
      sympy
      onnx
    ]
  );

  # TODO: build server, and move .so's to lib output
  # Python's wheel is stored in a separate dist output
  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals pythonSupport [ "dist" ];

  enableParallelBuilding = true;

  cmakeDir = "../cmake";

  cmakeFlags = [
    (lib.cmakeBool "ABSL_ENABLE_INSTALL" true)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "FETCHCONTENT_QUIET" false)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ABSEIL_CPP" "${abseil-cpp_202407.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DLPACK" "${dlpack}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FLATBUFFERS" "${flatbuffers_23.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MP11" "${mp11}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ONNX" "${onnx}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RE2" "${re2.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SAFEINT" "${safeint}")
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
    # fails to find protoc on darwin, so specify it
    (lib.cmakeFeature "ONNX_CUSTOM_PROTOC_EXECUTABLE" (lib.getExe protobuf))
    (lib.cmakeBool "onnxruntime_BUILD_SHARED_LIB" true)
    (lib.cmakeBool "onnxruntime_BUILD_UNIT_TESTS" doCheck)
    (lib.cmakeBool "onnxruntime_USE_FULL_PROTOBUF" withFullProtobuf)
    (lib.cmakeBool "onnxruntime_USE_CUDA" cudaSupport)
    (lib.cmakeBool "onnxruntime_USE_NCCL" (cudaSupport && ncclSupport))
    (lib.cmakeBool "onnxruntime_USE_ROCM" rocmSupport)
    (lib.cmakeBool "onnxruntime_ENABLE_LTO" (!cudaSupport || cudaPackages.cudaOlder "12.8"))
  ]
  ++ lib.optionals pythonSupport [
    (lib.cmakeBool "onnxruntime_ENABLE_PYTHON" true)
  ]
  ++ lib.optionals cudaSupport [
    # Werror and cudnn_frontend deprecations make for a bad time.
    "--compile-no-warning-as-error"
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CUTLASS" "${cutlass}")
    (lib.cmakeFeature "onnxruntime_CUDNN_HOME" "${cudaPackages.cudnn}")
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaArchitecturesString)
    (lib.cmakeFeature "onnxruntime_NVCC_THREADS" "1")
  ]
  ++ lib.optionals rocmSupport [
    # Werror combines with rocprim header issues to cause errors (warp size const deprecation)
    "--compile-no-warning-as-error"
    (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" (
      builtins.concatStringsSep ";" rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets
    ))
    (lib.cmakeFeature "onnxruntime_ROCM_HOME" "${rocmPackages.clr}")
    # Incompatible with packaged version, far too slow to build vendored version
    (lib.cmakeBool "onnxruntime_USE_COMPOSABLE_KERNEL" false)
    (lib.cmakeBool "onnxruntime_USE_COMPOSABLE_KERNEL_CK_TILE" false)
  ];

  env =
    lib.optionalAttrs effectiveStdenv.cc.isClang {
      NIX_CFLAGS_COMPILE = "-Wno-error";
    }
    // lib.optionalAttrs rocmSupport {
      MIOPEN_PATH = rocmPackages.miopen;
      # HIP steps fail to find ROCm libs when not in HIPFLAGS, causing
      # fatal error: 'rocrand/rocrand.h' file not found
      HIPFLAGS = lib.concatMapStringsSep " " (pkg: "-I${lib.getInclude pkg}/include") [
        rocmPackages.hipblas
        rocmPackages.hipcub
        rocmPackages.hiprand
        rocmPackages.hipsparse
        rocmPackages.rocblas
        rocmPackages.rocprim
        rocmPackages.rocrand
        rocmPackages.rocthrust
      ];
    };

  doCheck =
    !(
      cudaSupport
      || rocmSupport
      || builtins.elem effectiveStdenv.buildPlatform.system [
        # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox
        "aarch64-linux"
        # 1 - onnxruntime_test_all (Failed)
        # 4761 tests from 311 test suites ran, 57 failed.
        "loongarch64-linux"
      ]
    );

  requiredSystemFeatures = lib.optionals (cudaSupport || rocmSupport) [ "big-parallel" ];

  hardeningEnable = lib.optionals (effectiveStdenv.hostPlatform.system == "loongarch64-linux") [
    "nostrictaliasing"
  ];

  postPatch = ''
    substituteInPlace cmake/libonnxruntime.pc.cmake.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_ @CMAKE_INSTALL_
    echo "find_package(cudnn_frontend REQUIRED)" > cmake/external/cudnn_frontend.cmake

    # https://github.com/microsoft/onnxruntime/blob/c4f3742bb456a33ee9c826ce4e6939f8b84ce5b0/onnxruntime/core/platform/env.h#L249
    substituteInPlace onnxruntime/core/platform/env.h --replace-fail \
      "GetRuntimePath() const { return PathString(); }" \
      "GetRuntimePath() const { return PathString(\"$out/lib/\"); }"
  ''
  + lib.optionalString rocmSupport ''
    patchShebangs tools/ci_build/hipify-perl
  ''
  + lib.optionalString (effectiveStdenv.hostPlatform.system == "aarch64-linux") ''
    # https://github.com/NixOS/nixpkgs/pull/226734#issuecomment-1663028691
    rm -v onnxruntime/test/optimizer/nhwc_transformer_test.cc
  '';

  postBuild = lib.optionalString pythonSupport ''
    ${python3Packages.python.interpreter} ../setup.py bdist_wheel
  '';

  postInstall = ''
    # perform parts of `tools/ci_build/github/linux/copy_strip_binary.sh`
    install -m644 -Dt $out/include \
      ../include/onnxruntime/core/framework/provider_options.h \
      ../include/onnxruntime/core/providers/cpu/cpu_provider_factory.h \
      ../include/onnxruntime/core/session/onnxruntime_*.h
  '';

  # See comments in `cudaPackages.nccl`
  postFixup = lib.optionalString cudaSupport ''
    remove-references-to -t "${lib.getBin cuda_nvcc}" ''${!outputLib}/lib/libonnxruntime_providers_cuda.so
  '';
  disallowedRequisites = lib.optionals cudaSupport [ (lib.getBin cuda_nvcc) ];

  passthru = {
    inherit cudaSupport cudaPackages ncclSupport; # for the python module
    inherit protobuf;
    tests = lib.optionalAttrs pythonSupport {
      python = python3Packages.onnxruntime;
    };
  };

  meta = {
    description = "Cross-platform, high performance scoring engine for ML models";
    longDescription = ''
      ONNX Runtime is a performance-focused complete scoring engine
      for Open Neural Network Exchange (ONNX) models, with an open
      extensible architecture to continually address the latest developments
      in AI and Deep Learning. ONNX Runtime stays up to date with the ONNX
      standard with complete implementation of all ONNX operators, and
      supports all ONNX releases (1.2+) with both future and backwards
      compatibility.
    '';
    homepage = "https://github.com/microsoft/onnxruntime";
    changelog = "https://github.com/microsoft/onnxruntime/releases/tag/v${version}";
    # https://github.com/microsoft/onnxruntime/blob/master/BUILD.md#architectures
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      puffnfresh
      ck3d
    ];
  };
}
