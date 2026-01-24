{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  applyPatches,
  fetchpatch,
  fetchurl,
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

  # While onnxruntime suggests using (3 year-old) protobuf 21.12
  # https://github.com/microsoft/onnxruntime/blob/v1.23.2/cmake/deps.txt#L40, using a newer
  # protobuf version is possible.
  # We still need to patch the nixpkgs protobuf (32.1) to address the following test failure that
  # occurs when cudaSupport is enabled:
  # [libprotobuf ERROR /build/source/src/google/protobuf/descriptor_database.cc:642] File already exists in database: onnx/onnx-ml.proto
  # [libprotobuf FATAL /build/source/src/google/protobuf/descriptor.cc:1986] CHECK failed: GeneratedDatabase()->Add(encoded_file_descriptor, size):
  # terminate called after throwing an instance of 'google::protobuf::FatalException'
  #   what():  CHECK failed: GeneratedDatabase()->Add(encoded_file_descriptor, size):
  #
  #
  # Caused by: https://github.com/protocolbuffers/protobuf/commit/8f7aab29b21afb89ea0d6e2efeafd17ca71486a9
  # Reported upstream: https://github.com/protocolbuffers/protobuf/issues/21542
  protobuf' = protobuf.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (fetchpatch {
        name = "Workaround nvcc bug in message_lite.h";
        url = "https://raw.githubusercontent.com/conda-forge/protobuf-feedstock/737a13ea0680484c08e8e0ab0144dab82c10c1b3/recipe/patches/0010-Workaround-nvcc-bug-in-message_lite.h.patch";
        hash = "sha256-joK50Il4mrwIc6zuNW9gDIfOx9LuA4FlusJuzUf9kqI=";
      })
    ];
  });

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

  onnx-src = applyPatches {
    name = "onnx-src";
    src = fetchFromGitHub {
      owner = "onnx";
      repo = "onnx";
      tag = "v1.18.0";
      hash = "sha256-UhtF+CWuyv5/Pq/5agLL4Y95YNP63W2BraprhRqJOag=";
    };

    patches = [
      # Fix "error: conversion from 'onnx::OpSchema' to non-scalar type 'onnx::OpSchemaRegistry::OpSchemaRegisterOnce'"
      # https://github.com/microsoft/onnxruntime/issues/26229
      # Fix from https://github.com/onnx/onnx/pull/7390
      (fetchpatch {
        url = "https://github.com/onnx/onnx/commit/595a069aaac07586f111681245bc808ee63551f8.patch";
        includes = [ "onnx/defs/schema.h" ];
        hash = "sha256-FFAJuJse4nmNT3ixvEdlqzbr3edY46SqEFv7z/oo6m0=";
      })

      # Fix "undefined reference to `onnx::RNNShapeInference(onnx::InferenceContext&)'"
      (fetchpatch {
        url = "https://github.com/onnx/onnx/commit/6769c41ad64ebca0358da8c7211d2c6d0e627b2b.patch";
        hash = "sha256-VlTHs0om20kTNvSVQaasSsa5JROliQy4k9BECTsBtbU=";
      })
    ];
  };

  cutlass-src = fetchFromGitHub {
    name = "cutlass-src";
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v3.9.2";
    hash = "sha256-teziPNA9csYvhkG5t2ht8W8x5+1YGGbHm8VKx4JoxgI=";
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
  version = "1.23.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-hZ2L5+0Enkw4rGDKVpRECnKXP87w6Kbiyp6Fdxwt6hk=";
  };

  patches = [
    # Missing cstdint include (GCC 15 compatibility)
    (fetchpatch {
      url = "https://github.com/microsoft/onnxruntime/commit/d6e712c5b7b6260a61e54d1fe40107cf5366ee77.patch";
      hash = "sha256-FSuPybX8f2VoxvLhcYx4rdChaiK8bSUDR32sN3Efwfc=";
    })

    # Correct maybe-uninitialized and range-loop-construct warnings
    # https://github.com/microsoft/onnxruntime/pull/26201
    (fetchpatch {
      url = "https://github.com/microsoft/onnxruntime/commit/8ebd0bf1cf02414584d15d7244b07fa97d65ba02.patch";
      hash = "sha256-vX+kaFiNdmqWI91JELcLpoaVIHBb5EPbI7rCAMYAx04=";
    })

    # Skip execinfo include on musl
    # https://github.com/microsoft/onnxruntime/pull/25726
    ./musl-execinfo.patch
    # Add missing include which is only needed on musl (is implied in other includes on glibc)
    # https://github.com/microsoft/onnxruntime/pull/26969
    ./musl-cstdint.patch

    # Fix build of unit tests with musl libc
    # https://github.com/microsoft/onnxruntime/issues/9155
    (fetchurl {
      url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/462dfe0eb4b66948fe48de44545cc22bb64fdf9f/community/onnxruntime/0001-Remove-MATH_NO_EXCEPT-macro.patch";
      hash = "sha256-BdeGYevZExWWCuJ1lSw0Roy3h+9EbJgFF8qMwVxSn1A=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
    protobuf'
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
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "FETCHCONTENT_QUIET" false)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ABSEIL_CPP" "${abseil-cpp_202407.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DLPACK" "${dlpack-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FLATBUFFERS" "${flatbuffers_23.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MP11" "${mp11-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ONNX" "${onnx-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RE2" "${re2.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SAFEINT" "${safeint-src}")
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
    # fails to find protoc on darwin, so specify it
    (lib.cmakeFeature "ONNX_CUSTOM_PROTOC_EXECUTABLE" (lib.getExe protobuf'))
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

  postPatch = ''
    substituteInPlace cmake/libonnxruntime.pc.cmake.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_ @CMAKE_INSTALL_
    echo "find_package(cudnn_frontend REQUIRED)" > cmake/external/cudnn_frontend.cmake
  ''
  # https://github.com/microsoft/onnxruntime/blob/c4f3742bb456a33ee9c826ce4e6939f8b84ce5b0/onnxruntime/core/platform/env.h#L249
  + ''
    substituteInPlace onnxruntime/core/platform/env.h --replace-fail \
      "GetRuntimePath() const { return PathString(); }" \
      "GetRuntimePath() const { return PathString(\"$out/lib/\"); }"
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
    protobuf = protobuf';
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
