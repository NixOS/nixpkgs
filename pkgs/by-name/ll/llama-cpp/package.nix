{
  lib,
  autoAddDriverRunpath,
  cmake,
  fetchFromGitHub,
  installShellFiles,
  stdenv,

  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },

  rocmSupport ? config.rocmSupport,
  rocmPackages ? { },
  rocmGpuTargets ? rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets,

  cpuArchDynamicDispatch ? true,

  openclSupport ? false,
  clblast,

  blasSupport ? builtins.all (x: !x) [
    cudaSupport
    metalSupport
    openclSupport
    rocmSupport
    vulkanSupport
  ],
  blas,

  fetchNpmDeps,
  nodejs_latest,
  npmHooks,

  pkg-config,
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
  buildNumber = "10566";
  buildCommit = "bb4caa7";

  # It's necessary to consistently use backendStdenv when building with CUDA support,
  # otherwise we get libstdc++ errors downstream.
  # cuda imposes an upper bound on the gcc version
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
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
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "llama-cpp";
  version = "0.2.0";

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
    hash = "sha256-46b+5YWwF5k1vBBzsjSCrn6k8dkPuBYy2bqWhgFqCbQ=";
  };

  patches = [ ];

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

  buildInputs =
    optionals cudaSupport cudaBuildInputs
    ++ optionals openclSupport [ clblast ]
    ++ optionals rocmSupport rocmBuildInputs
    ++ optionals blasSupport [ blas ]
    ++ optionals vulkanSupport vulkanBuildInputs
    ++ [ openssl ];

  npmRoot = "tools/ui";
  npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";
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
    (cmakeBool "LLAMA_BUILD_IS_DEV" false)
    (cmakeBool "LLAMA_OPENSSL" true)
    (cmakeBool "BUILD_SHARED_LIBS" true)
    (cmakeBool "GGML_BLAS" blasSupport)
    (cmakeBool "GGML_CLBLAST" openclSupport)
    (cmakeBool "GGML_CUDA" cudaSupport)
    (cmakeBool "GGML_HIP" rocmSupport)
    (cmakeBool "GGML_METAL" metalSupport)
    (cmakeBool "GGML_RPC" rpcSupport)
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
  ];

  postInstall = optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd llama-server --bash <($out/bin/llama-server --completion-bash)
  '';

  # the tests are failing as of 2025-08
  doCheck = false;

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Inference of Meta's LLaMA model (and others) in pure C/C++";
    homepage = "https://github.com/ggml-org/llama.cpp";
    license = lib.licenses.mit;
    mainProgram = "llama";
    maintainers = with lib.maintainers; [
      booxter
      philiptaron
      xddxdd
      yuannan
    ];
    teams = [ lib.teams.cuda ];
    platforms = lib.platforms.unix;
    badPlatforms = optionals (cudaSupport || openclSupport) lib.platforms.darwin;
    broken = metalSupport && !effectiveStdenv.hostPlatform.isDarwin;
  };
})
