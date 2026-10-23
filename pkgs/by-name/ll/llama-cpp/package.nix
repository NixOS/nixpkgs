{
  lib,
  buildPackages,
  autoAddDriverRunpath,
  cmake,
  ctestCheckHook,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  stdenv,

  config,
  # The SYCL build uses the oneAPI stdenv, which a CUDA build would replace.
  cudaSupport ? config.cudaSupport && !syclSupport,
  cudaPackages ? { },

  rocmSupport ? config.rocmSupport,
  rocmPackages ? { },
  rocmGpuTargets ? rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets,

  syclSupport ? false,
  intel-oneapi-toolkit,
  level-zero,

  cpuArchDynamicDispatch ? true,

  openclSupport ? false,
  clblast,

  blasSupport ? builtins.all (x: !x) [
    cudaSupport
    metalSupport
    openclSupport
    rocmSupport
    syclSupport
    vulkanSupport
  ],
  blas,

  fetchNpmDeps,
  nodejs_latest,
  npmHooks,

  pkg-config,
  python3,
  metalSupport ? stdenv.hostPlatform.isDarwin && !openclSupport,
  vulkanSupport ? false,
  rpcSupport ? false,
  openssl,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  spirv-headers,
  ninja,
}:

let
  # Upstream reads these from git, which the release tarball does not ship.
  # They are purely informational: `llama-server --version`, `/props`, and the web UI.
  buildNumber = "11429";
  buildCommit = "d812350";

  # It's necessary to consistently use backendStdenv when building with CUDA support,
  # otherwise we get libstdc++ errors downstream.
  # cuda imposes an upper bound on the gcc version
  effectiveStdenv =
    if cudaSupport then
      cudaPackages.backendStdenv
    # The SYCL backend needs the oneAPI DPC++ compiler.
    else if syclSupport then
      intel-oneapi-toolkit.stdenv
    else
      stdenv;
  inherit (lib)
    cmakeBool
    cmakeFeature
    optionals
    optionalString
    ;

  cudaBuildInputs = with cudaPackages; [
    cccl # <nv/target>

    # A temporary hack for reducing the closure size, remove once cudaPackages
    # have stopped using lndir: https://github.com/NixOS/nixpkgs/issues/271792
    cuda_cudart
    libcublas
  ];

  rocmBuildInputs = with rocmPackages; [
    clr
    hipblas
    rocblas
  ];

  vulkanBuildInputs = [
    spirv-headers
    vulkan-headers
    vulkan-loader
  ];

  buildCc = buildPackages.stdenv.cc;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "llama-cpp";
  version = "0.6.0";

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l6l6JIlIVTaVC6xh5M4fRHFtXsweQuugtkNTWHcZZF4=";
  };

  patches = [
    # Initialize dynamically loaded backends before generating test models.
    # https://github.com/ggml-org/llama.cpp/pull/30034
    (fetchpatch {
      url = "https://github.com/ggml-org/llama.cpp/commit/07ccce23cf7fe3c84e13d810accff672b1d966bf.patch";
      hash = "sha256-KtsPcveFM51fY1hDWntiqCW/KHoWLv05Gmnhd1U/9Zs=";
    })
  ];

  nativeBuildInputs = [
    cmake
    installShellFiles
    ninja
    nodejs_latest
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ]
  # `glslc` is used at build time to compile the shaders
  ++ optionals vulkanSupport [
    shaderc
  ];

  depsBuildBuild = optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # llama-ui-embed under tools/ui needs a host compiler
    buildCc
  ];

  buildInputs =
    optionals cudaSupport cudaBuildInputs
    ++ optionals openclSupport [ clblast ]
    ++ optionals rocmSupport rocmBuildInputs
    ++ optionals syclSupport [
      intel-oneapi-toolkit
      level-zero
    ]
    ++ optionals blasSupport [ blas ]
    ++ optionals vulkanSupport vulkanBuildInputs
    ++ [ openssl ];

  # Fortify adds __memcpy_chk references to the SYCL device code, which the GPU
  # driver cannot resolve when it compiles the kernels at runtime.
  hardeningDisable = optionals syclSupport [
    "fortify"
    "fortify3"
  ];

  npmRoot = "tools/ui";
  npmDepsHash = "sha256-a17M+L3nLdRnN6WMB6imPFmwqG2g8uv+gwN0XTAUrf8=";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src patches;
    preBuild = ''
      pushd ${finalAttrs.npmRoot}
    '';
    hash = finalAttrs.npmDepsHash;
  };

  preConfigure = ''
    pushd ${finalAttrs.npmRoot}
    LLAMA_BUILD_NUMBER=${buildNumber} npm run build
    popd
  '';

  cmakeFlags = [
    (cmakeBool "GGML_NATIVE" false) # -march=native would make builds non-deterministic
    (cmakeBool "LLAMA_BUILD_EXAMPLES" false)
    (cmakeBool "LLAMA_BUILD_SERVER" true)
    (cmakeBool "LLAMA_BUILD_TESTS" (finalAttrs.finalPackage.doCheck or false))
    (cmakeBool "LLAMA_TESTS_INSTALL" false)
    (cmakeBool "LLAMA_BUILD_IS_DEV" false)
    (cmakeBool "LLAMA_OPENSSL" true)
    (cmakeBool "BUILD_SHARED_LIBS" true)
    (cmakeBool "GGML_BLAS" blasSupport)
    (cmakeBool "GGML_CLBLAST" openclSupport)
    (cmakeBool "GGML_CUDA" cudaSupport)
    (cmakeBool "GGML_HIP" rocmSupport)
    (cmakeBool "GGML_METAL" metalSupport)
    (cmakeBool "GGML_RPC" rpcSupport)
    (cmakeBool "GGML_SYCL" syclSupport)
    (cmakeBool "GGML_VULKAN" vulkanSupport)
    (cmakeFeature "LLAMA_BUILD_NUMBER" buildNumber)
    (cmakeFeature "LLAMA_BUILD_COMMIT" buildCommit)
  ]
  ++ optionals cpuArchDynamicDispatch [
    # Build all CPU backend variants for runtime dynamic dispatch.
    # This avoids illegal instructions on older CPUs and gives optimal performance
    # on newer ones without needing separate builds.
    # Enabling AVX2 can make CPU inference 13x faster compared to NixOS's x86_64 defaults.
    # Note it is not a bug that the CPU variant .so files are placed in `bin/`
    # (as opposed to `lib/`) alongside the executables by upstream's `CMakeLists.txt` design:
    # * https://github.com/ggml-org/llama.cpp/blob/b46812de78f8fbcb6cf0154947e8633ebc78d9ac/ggml/src/CMakeLists.txt#L249-L252
    # * https://github.com/ggml-org/llama.cpp/blob/b46812de78f8fbcb6cf0154947e8633ebc78d9ac/ggml/src/ggml-backend-reg.cpp#L480-L486
    (cmakeBool "GGML_CPU_ALL_VARIANTS" true)
    (cmakeBool "GGML_BACKEND_DL" true)
    # Let libggml find the backends when it is loaded from another package.
    (cmakeFeature "GGML_BACKEND_DIR" "${placeholder "out"}/bin")
  ]
  ++ optionals cudaSupport [
    (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ]
  ++ optionals rocmSupport [
    (cmakeFeature "CMAKE_HIP_COMPILER" "${rocmPackages.clr.hipClangPath}/clang++")
    (cmakeFeature "CMAKE_HIP_ARCHITECTURES" (builtins.concatStringsSep ";" rocmGpuTargets))
  ]
  ++ optionals metalSupport [
    (cmakeFeature "CMAKE_C_FLAGS" "-D__ARM_FEATURE_DOTPROD=1")
    (cmakeBool "LLAMA_METAL_EMBED_LIBRARY" true)
  ]
  ++ optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    (cmakeFeature "HOST_CXX_COMPILER" (lib.getExe' buildCc "${buildCc.targetPrefix}c++"))
  ];

  postInstall = optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd llama-server --bash <($out/bin/llama-server --completion-bash)
  '';

  doCheck = true;

  # Use CTest to skip disabled tests.
  dontUseNinjaCheck = true;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    ctestCheckHook
    (python3.withPackages (ps: [ ps.jinja2 ]))
  ];

  preCheck =
    optionalString metalSupport ''
      export GGML_METAL_DEVICES=0
    ''
    # The SYCL backend exits on this check when there is no device.
    + optionalString syclSupport ''
      export GGML_SYCL_USE_ASYNC_MEM_OP=0
    '';

  disabledTests = [
    # Network needed.
    "test-tokenizers-ggml-vocabs"
    "test-download-model"
    "test-arg-parser"
    "test-thread-safety"
    "test-state-restore-fragmented"
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description =
      "Inference of Meta's LLaMA model (and others) in pure C/C++"
      + optionalString cudaSupport ", with CUDA support"
      + optionalString rocmSupport ", with ROCm support"
      + optionalString syclSupport ", with SYCL support"
      + optionalString vulkanSupport ", with Vulkan support";
    homepage = "https://github.com/ggml-org/llama.cpp";
    license =
      if syclSupport then
        # Parts of the SYCL backend come from LLVM.
        lib.licenses.AND [
          lib.licenses.mit
          (lib.licenses.WITH lib.licenses.asl20 lib.licenses.llvm-exception)
        ]
      else
        lib.licenses.mit;
    mainProgram = "llama";
    maintainers = with lib.maintainers; [
      booxter
      philiptaron
      recutita
      xddxdd
      yuannan
    ];
    teams = [ lib.teams.cuda ];
    platforms =
      if syclSupport then
        lib.intersectLists lib.platforms.unix intel-oneapi-toolkit.meta.platforms
      else
        lib.platforms.unix;
    badPlatforms = optionals (cudaSupport || openclSupport) lib.platforms.darwin;
    broken =
      metalSupport && !effectiveStdenv.hostPlatform.isDarwin
      # ggml-sycl needs icpx as the C++ compiler, which the CUDA stdenv replaces.
      || cudaSupport && syclSupport;
  };
})
