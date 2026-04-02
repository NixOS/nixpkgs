{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  abseil-cpp_202508,
  cmake,
  cpuinfo,
  eigen,
  flatbuffers_23,
  glibcLocales,
  gtest,
  howard-hinnant-date,
  libpng,
  nlohmann_json,
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
  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv;
  inherit (cudaPackages) cuda_nvcc;

  cudaArchitecturesString = cudaPackages.flags.cmakeCudaArchitecturesString;

  # TODO: update the following dependencies according to:
  # https://github.com/microsoft/onnxruntime/blob/v<VERSION>/cmake/deps.txt

  mp11-src = fetchFromGitHub {
    name = "mp11-src";
    owner = "boostorg";
    repo = "mp11";
    tag = "boost-1.82.0";
    hash = "sha256-cLPvjkf2Au+B19PJNrUkTW/VPxybi1MpPxnIl4oo4/o=";
  };

  safeint-src = fetchFromGitHub {
    name = "safeint-src";
    owner = "dcleblanc";
    repo = "safeint";
    tag = "3.0.28";
    hash = "sha256-pjwjrqq6dfiVsXIhbBtbolhiysiFlFTnx5XcX77f+C0=";
  };

  onnx-src = fetchFromGitHub {
    name = "onnx-src";
    owner = "onnx";
    repo = "onnx";
    tag = "v1.20.1";
    hash = "sha256-XZJXD6sBvVJ6cLPyDkKOW8oSkjqcw9whUqDWd7dxY3c=";
  };

  cutlass-src = fetchFromGitHub {
    name = "cutlass-src";
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v4.2.1";
    hash = "sha256-iP560D5Vwuj6wX1otJhwbvqe/X4mYVeKTpK533Wr5gY=";
  };

  dlpack-src = fetchFromGitHub {
    name = "dlpack-src";
    owner = "dmlc";
    repo = "dlpack";
    rev = "5c210da409e7f1e51ddf445134a4376fdbd70d7d";
    hash = "sha256-YqgzCyNywixebpHGx16tUuczmFS5pjCz5WjR89mv9eI=";
  };

  isCudaJetson = cudaSupport && cudaPackages.flags.isJetsonBuild;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "onnxruntime";
  version = "1.24.4";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-CjPgRkPyp7dUPAOo3cePWQvucOlQAwtT4NO5w3NkV+E=";
  };

  patches = [
    # Skip execinfo include on musl
    # https://github.com/microsoft/onnxruntime/pull/25726
    ./musl-execinfo.patch
    # Add missing include which is only needed on musl (is implied in other includes on glibc)
    # https://github.com/microsoft/onnxruntime/pull/26969
    ./musl-cstdint.patch

    # Fix build of unit tests with musl libc
    # https://github.com/microsoft/onnxruntime/issues/9155
    # Patch adapted from https://gitlab.alpinelinux.org/alpine/aports/-/raw/462dfe0eb4b66948fe48de44545cc22bb64fdf9f/community/onnxruntime/0001-Remove-MATH_NO_EXCEPT-macro.patch
    ./remove-MATH_NO_EXCEPT-macro.patch

    # Fix build of ignored outputs after Protobuf 34 added `[[nodiscard]]` to
    # many functions.
    ./protobuf34-nodiscard.patch
  ];

  postPatch = ''
    substituteInPlace cmake/libonnxruntime.pc.cmake.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_ @CMAKE_INSTALL_
    echo "find_package(cudnn_frontend REQUIRED)" > cmake/external/cudnn_frontend.cmake
  ''
  + ''
    substituteInPlace onnxruntime/core/platform/posix/env.cc --replace-fail \
      "return PathString{};" \
      "return PathString(\"$out/lib/\");"
  ''
  + lib.optionalString rocmSupport ''
    patchShebangs tools/ci_build/hipify-perl
  ''
  # https://github.com/NixOS/nixpkgs/pull/226734#issuecomment-1663028691
  + lib.optionalString (effectiveStdenv.hostPlatform.system == "aarch64-linux") ''
    rm -v onnxruntime/test/optimizer/nhwc_transformer_test.cc
  '';

  postBuild = lib.optionalString pythonSupport ''
    ${python3Packages.python.interpreter} ../setup.py bdist_wheel
  '';

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
    rocmPackages.hipblaslt
    rocmPackages.hipcub
    rocmPackages.hipfft
    rocmPackages.hiprand
    rocmPackages.hipsparse
    rocmPackages.rocblas
    rocmPackages.rocprim
    rocmPackages.rocrand
    rocmPackages.rocthrust
    rocmPackages.miopen
    rocmPackages.migraphx
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
      onnx
      pytest
      sympy
    ]
  );

  # TODO: build server, and move .so's to lib output
  # Python's wheel is stored in a separate dist output
  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals pythonSupport [ "dist" ];

  separateDebugInfo = true;

  enableParallelBuilding = true;

  cmakeDir = "../cmake";

  cmakeFlags = [
    (lib.cmakeBool "ABSL_ENABLE_INSTALL" true)
    # leads to failing builds, which isn't particularly useful for Nixpkgs
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-error=unused-variable")
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "FETCHCONTENT_QUIET" false)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ABSEIL_CPP" "${abseil-cpp_202508.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DLPACK" "${dlpack-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FLATBUFFERS" "${flatbuffers_23.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MP11" "${mp11-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ONNX" "${onnx-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RE2" "${re2.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SAFEINT" "${safeint-src}")
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
    # fails to find protoc on darwin, so specify it
    (lib.cmakeFeature "ONNX_CUSTOM_PROTOC_EXECUTABLE" (lib.getExe protobuf))
    (lib.cmakeBool "onnxruntime_BUILD_SHARED_LIB" true)
    (lib.cmakeBool "onnxruntime_BUILD_UNIT_TESTS" finalAttrs.doCheck)
    (lib.cmakeBool "onnxruntime_USE_FULL_PROTOBUF" withFullProtobuf)
    (lib.cmakeBool "onnxruntime_USE_CUDA" cudaSupport)
    (lib.cmakeBool "onnxruntime_USE_NCCL" (cudaSupport && ncclSupport))
    (lib.cmakeBool "onnxruntime_USE_MIGRAPHX" rocmSupport)
    (lib.cmakeBool "onnxruntime_ENABLE_LTO" (!cudaSupport || cudaPackages.cudaOlder "12.8"))
  ]
  ++ lib.optionals pythonSupport [
    (lib.cmakeBool "onnxruntime_ENABLE_PYTHON" true)
  ]
  ++ lib.optionals cudaSupport [
    # Werror and cudnn_frontend deprecations make for a bad time.
    "--compile-no-warning-as-error"
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CUTLASS" "${cutlass-src}")
    (lib.cmakeFeature "onnxruntime_CUDNN_HOME" "${cudaPackages.cudnn}")
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaArchitecturesString)
    (lib.cmakeFeature "onnxruntime_NVCC_THREADS" "1")
  ]
  ++ lib.optionals rocmSupport [
    (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" (
      builtins.concatStringsSep ";" rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets
    ))
    (lib.cmakeFeature "onnxruntime_ROCM_HOME" "${rocmPackages.clr}")
    # Incompatible with packaged version, far too slow to build vendored version
    (lib.cmakeBool "onnxruntime_USE_COMPOSABLE_KERNEL" false)
    (lib.cmakeBool "onnxruntime_USE_COMPOSABLE_KERNEL_CK_TILE" false)
  ];

  env =
    lib.optionalAttrs effectiveStdenv.hostPlatform.isLinux {
      NIX_LDFLAGS = "-z,noexecstack";
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
    }
    // lib.optionalAttrs effectiveStdenv.hostPlatform.isMusl {
      NIX_CFLAGS_COMPILE = "-DFLATBUFFERS_LOCALE_INDEPENDENT=0";
      GTEST_FILTER = "*:-ContribOpTest.StringNormalizer*";
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
  hardeningDisable = lib.optional effectiveStdenv.hostPlatform.isMusl "fortify";

  # perform parts of `tools/ci_build/github/linux/copy_strip_binary.sh`
  postInstall = ''
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

  __structuredAttrs = true;

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
    changelog = "https://github.com/microsoft/onnxruntime/releases/tag/${finalAttrs.src.tag}";
    # https://github.com/microsoft/onnxruntime/blob/master/BUILD.md#architectures
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      puffnfresh
      ck3d
    ];
    #  [libprotobuf ERROR /build/source/src/google/protobuf/descriptor_database.cc:642] File already
    # exists in database: onnx/onnx-ml.proto
    # https://github.com/onnx/onnx/issues/6094
    broken = withFullProtobuf;
  };
})
