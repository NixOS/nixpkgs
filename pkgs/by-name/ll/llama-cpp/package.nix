{
  lib,
  autoAddDriverRunpath,
  cmake,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
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
  metalSupport ? stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 && !openclSupport,
  vulkanSupport ? false,
  rpcSupport ? false,
  openssl,
  llama-cpp,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  spirv-headers,
  ninja,
}:

let
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
    cuda_cccl # <nv/target>

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
    shaderc
    vulkan-headers
    vulkan-loader
  ];
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "llama-cpp";
  version = "9608";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = "b${finalAttrs.version}";
    hash = "sha256-nNQzEfSqVwusixHdiZCyAOtrQTQ7aAdV+S9qZywWWx0=";
    leaveDotGit = true;
    postFetch = ''
      git -C "$out" rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  patches = [ ];

  nativeBuildInputs = [
    cmake
    installShellFiles
    ninja
    nodejs_latest
    npmHooks.npmConfigHook
    pkg-config
    spirv-headers
  ]
  ++ optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];

  buildInputs =
    optionals cudaSupport cudaBuildInputs
    ++ optionals openclSupport [ clblast ]
    ++ optionals rocmSupport rocmBuildInputs
    ++ optionals blasSupport [ blas ]
    ++ optionals vulkanSupport vulkanBuildInputs
    ++ [ openssl ];

  npmRoot = "tools/ui";
  npmDepsHash = "sha256-pjdbI6NcZRlJVd62xhgbLhWrwFYwgsIwjORqvo1+VD8=";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src patches;
    preBuild = ''
      pushd ${finalAttrs.npmRoot}
    '';
    hash = finalAttrs.npmDepsHash;
  };

  preConfigure = ''
    prependToVar cmakeFlags "-DLLAMA_BUILD_COMMIT:STRING=$(cat COMMIT)"
    pushd ${finalAttrs.npmRoot}
    npm run build
    popd
  '';

  cmakeFlags = [
    (cmakeBool "GGML_NATIVE" false) # -march=native would make builds non-deterministic
    (cmakeBool "LLAMA_BUILD_EXAMPLES" false)
    (cmakeBool "LLAMA_BUILD_SERVER" true)
    (cmakeBool "LLAMA_BUILD_TESTS" (finalAttrs.finalPackage.doCheck or false))
    (cmakeBool "LLAMA_OPENSSL" true)
    (cmakeBool "BUILD_SHARED_LIBS" true)
    (cmakeBool "GGML_BLAS" blasSupport)
    (cmakeBool "GGML_CLBLAST" openclSupport)
    (cmakeBool "GGML_CUDA" cudaSupport)
    (cmakeBool "GGML_HIP" rocmSupport)
    (cmakeBool "GGML_METAL" metalSupport)
    (cmakeBool "GGML_RPC" rpcSupport)
    (cmakeBool "GGML_VULKAN" vulkanSupport)
    (cmakeFeature "LLAMA_BUILD_NUMBER" finalAttrs.version)
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
  ]
  ++ optionals rpcSupport [
    # This is done so we can move rpc-server out of bin because llama.cpp doesn't
    # install rpc-server in their install target.
    (cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
  ];

  # upstream plans on adding targets at the cmakelevel, remove those
  # additional steps after that
  postInstall = ''
    # Match previous binary name for this package
    ln -sf $out/bin/llama-cli $out/bin/llama

    mkdir -p $out/include
    cp $src/include/llama.h $out/include/

  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd llama-server --bash <($out/bin/llama-server --completion-bash)
  ''
  + optionalString rpcSupport "cp bin/rpc-server $out/bin/llama-rpc-server";

  # the tests are failing as of 2025-08
  doCheck = false;

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
      metal = llama-cpp.override { metalSupport = true; };
    };
    updateScript = nix-update-script {
      attrPath = "llama-cpp";
      extraArgs = [
        "--version-regex"
        "b(.*)"
      ];
    };
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
    platforms = lib.platforms.unix;
    badPlatforms = optionals (cudaSupport || openclSupport) lib.platforms.darwin;
    broken = metalSupport && !effectiveStdenv.hostPlatform.isDarwin;
  };
})
