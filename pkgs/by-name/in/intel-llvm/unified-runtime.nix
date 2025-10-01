{
  stdenv,
  lib,
  cmake,
  ninja,
  unified-memory-framework,
  zlib,
  libbacktrace,
  hwloc,
  python3,
  symlinkJoin,
  level-zero,
  intel-compute-runtime,
  opencl-headers,
  ocl-icd,
  hdrhistogram_c,
  gtest,
  pkg-config,
  lit,
  filecheck,
  rocmPackages ? { },
  rocmGpuTargets ? lib.optionalString (rocmPackages != { }) (
    builtins.concatStringsSep ";" rocmPackages.clr.gpuTargets
  ),
  intel-llvm-src,
  levelZeroSupport,
  openclSupport,
  # Broken, see unwrapped.nix
  cudaSupport,
  rocmSupport,
  nativeCpuSupport,
}:
let
  version = "0.12.0";
  rocmtoolkit_joined = symlinkJoin {
    name = "rocm-merged";

    paths = with rocmPackages; [
      clr
      rocm-comgr
      hsakmt
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  name = "unified-runtime";
  inherit version;

  src = intel-llvm-src;
  sourceRoot = "source/unified-runtime";

  doCheck = true;

  nativeBuildInputs = [
    cmake
    ninja
    python3
    pkg-config
  ];

  buildInputs = [
    unified-memory-framework
    zlib
    libbacktrace
    hwloc
    hdrhistogram_c
  ]
  ++ lib.optionals openclSupport [
    opencl-headers
    ocl-icd
  ]
  ++ lib.optionals rocmSupport [
    rocmtoolkit_joined
  ]
  ++ lib.optionals levelZeroSupport [
    level-zero
    intel-compute-runtime
  ]
  ++ lib.optionals finalAttrs.doCheck [
    gtest
    lit
    filecheck
  ];

  # Without this it fails to link to hwloc, despite it being in the buildInputs
  NIX_LDFLAGS = "-lhwloc";

  postPatch = ''
    # `NO_CMAKE_PACKAGE_REGISTRY` prevents it from finding OpenCL, so we unset it
    # Note that this cmake file is imported in various places, not just unified-runtime
    # See also: https://github.com/intel/llvm/issues/19635#issuecomment-3247008981
    substituteInPlace cmake/FetchOpenCL.cmake \
        --replace-fail "NO_CMAKE_PACKAGE_REGISTRY" ""
  ''
  + lib.optionalString finalAttrs.doCheck ''
    # These tests don't run without setting UR_DPCXX,
    # however they aren't properly excluded, causing lit to fail.
    rm test/adapters/hip/lit.cfg.py

    # Exclude tests that don't play well with the sandbox
    cat >> test/lit.cfg.py <<'EOF'
    # Conformance tests need to have an adapter to run on.
    # Within the sandbox, the only possible option is the CPU adapter.
    # If we don't have that, much of the conformance suite will fail, so we exclude it entirely.
    ${lib.optionalString (!nativeCpuSupport) "config.excludes.add('conformance')"}

    config.excludes.add('asan.cpp')
    config.excludes.add('loader_lifetime.test')
    EOF
  '';

  preCheck = lib.optionalString levelZeroSupport ''
    export LD_LIBRARY_PATH="${intel-compute-runtime.drivers}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  '';

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "FETCHCONTENT_QUIET" false)

    (lib.cmakeBool "UR_ENABLE_LATENCY_HISTOGRAM" true)

    (lib.cmakeBool "UR_BUILD_TESTS" finalAttrs.doCheck)
    # The test hello_world.test depends on the hello_world example, so build examples when testing
    (lib.cmakeBool "UR_BUILD_EXAMPLES" finalAttrs.doCheck)

    (lib.cmakeBool "UR_BUILD_ADAPTER_L0" levelZeroSupport)
    (lib.cmakeBool "UR_BUILD_ADAPTER_L0_V2" levelZeroSupport)
    (lib.cmakeBool "UR_BUILD_ADAPTER_OPENCL" openclSupport)
    (lib.cmakeBool "UR_BUILD_ADAPTER_CUDA" cudaSupport)
    (lib.cmakeBool "UR_BUILD_ADAPTER_HIP" rocmSupport)
    (lib.cmakeBool "UR_BUILD_ADAPTER_NATIVE_CPU" nativeCpuSupport)

    # In the sandbox we only have native_cpu available,
    # so we won't be able to test on any other backend.
    (lib.cmakeFeature "UR_CONFORMANCE_SELECTOR" "native_cpu:*")
  ]
  ++ lib.optionals rocmSupport [
    (lib.cmakeFeature "UR_HIP_ROCM_DIR" "${rocmtoolkit_joined}")
    (lib.cmakeFeature "AMDGPU_TARGETS" rocmGpuTargets)
  ];

  meta = with lib; {
    description = "Intel LLVM-based compiler with SYCL support";
    longDescription = ''
      Intel's LLVM-based compiler toolchain with Data Parallel C++ (DPC++)
      and SYCL support for heterogeneous computing across CPUs, GPUs, and FPGAs.
    '';
    homepage = "https://github.com/intel/llvm";
    license = with licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with maintainers; [ blenderfreaky ];
    broken = cudaSupport;
    platforms = [ "x86_64-linux" ];
  };
})
