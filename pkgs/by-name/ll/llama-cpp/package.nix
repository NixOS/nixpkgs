{
  lib,
  autoAddDriverRunpath,
  cmake,
  fetchFromGitHub,
  nix-update-script,
  stdenv,

  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },

  rocmSupport ? config.rocmSupport,
  rocmPackages ? { },

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

  pkg-config,
  metalSupport ? stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 && !openclSupport,
  vulkanSupport ? false,
  rpcSupport ? false,
  curl,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  ninja,
  git,
}:

let
  # It's necessary to consistently use backendStdenv when building with CUDA support,
  # otherwise we get libstdc++ errors downstream.
  # cuda imposes an upper bound on the gcc version, e.g. the latest gcc compatible with cudaPackages_11 is gcc11
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
  version = "5760";

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = "b${finalAttrs.version}";
    hash = "sha256-sl1lhj40c546YRuCTn6BlmS60Rd2TBKNx4TaQ0I6110=";
    leaveDotGit = true;
    postFetch = ''
      git -C "$out" rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  postPatch = ''
    # Workaround for local-ai package which overrides this package to an older llama-cpp
    if [ -f ./ggml/src/ggml-metal.m ]; then
      substituteInPlace ./ggml/src/ggml-metal.m \
        --replace-fail '[bundle pathForResource:@"ggml-metal" ofType:@"metal"];' "@\"$out/bin/ggml-metal.metal\";"
    fi

    if [ -f ./ggml/src/ggml-metal/ggml-metal.m ]; then
      substituteInPlace ./ggml/src/ggml-metal/ggml-metal.m \
        --replace-fail '[bundle pathForResource:@"ggml-metal" ofType:@"metal"];' "@\"$out/bin/ggml-metal.metal\";"
    fi

    substituteInPlace ./scripts/build-info.sh \
      --replace-fail 'build_number="0"' 'build_number="${finalAttrs.version}"' \
      --replace-fail 'build_commit="unknown"' "build_commit=\"$(cat COMMIT)\""
  '';

  nativeBuildInputs =
    [
      cmake
      ninja
      pkg-config
      git
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
    ++ [ curl ];

  cmakeFlags =
    [
      # -march=native is non-deterministic; override with platform-specific flags if needed
      (cmakeBool "GGML_NATIVE" false)
      (cmakeBool "LLAMA_BUILD_SERVER" true)
      (cmakeBool "LLAMA_CURL" true)
      (cmakeBool "BUILD_SHARED_LIBS" true)
      (cmakeBool "GGML_BLAS" blasSupport)
      (cmakeBool "GGML_CLBLAST" openclSupport)
      (cmakeBool "GGML_CUDA" cudaSupport)
      (cmakeBool "GGML_HIP" rocmSupport)
      (cmakeBool "GGML_METAL" metalSupport)
      (cmakeBool "GGML_RPC" rpcSupport)
      (cmakeBool "GGML_VULKAN" vulkanSupport)
    ]
    ++ optionals cudaSupport [
      (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
    ]
    ++ optionals rocmSupport ([
      (cmakeFeature "CMAKE_HIP_COMPILER" "${rocmPackages.clr.hipClangPath}/clang++")
      # TODO: this should become `clr.gpuTargets` in the future.
      (cmakeFeature "CMAKE_HIP_ARCHITECTURES" rocmPackages.rocblas.amdgpu_targets)
    ])
    ++ optionals metalSupport [
      (cmakeFeature "CMAKE_C_FLAGS" "-D__ARM_FEATURE_DOTPROD=1")
      (cmakeBool "LLAMA_METAL_EMBED_LIBRARY" true)
    ]
    ++ optionals rpcSupport [
      # This is done so we can move rpc-server out of bin because llama.cpp doesn't
      # install rpc-server in their install target.
      "-DCMAKE_SKIP_BUILD_RPATH=ON"
    ];

  # upstream plans on adding targets at the cmakelevel, remove those
  # additional steps after that
  postInstall =
    ''
      # Match previous binary name for this package
      ln -sf $out/bin/llama-cli $out/bin/llama

      mkdir -p $out/include
      cp $src/include/llama.h $out/include/
    ''
    + optionalString rpcSupport "cp bin/rpc-server $out/bin/llama-rpc-server";

  passthru.updateScript = nix-update-script {
    attrPath = "llama-cpp";
    extraArgs = [
      "--version-regex"
      "b(.*)"
    ];
  };

  meta = with lib; {
    description = "Inference of Meta's LLaMA model (and others) in pure C/C++";
    homepage = "https://github.com/ggml-org/llama.cpp";
    license = licenses.mit;
    mainProgram = "llama";
    maintainers = with maintainers; [
      dit7ya
      elohmeier
      philiptaron
      xddxdd
    ];
    platforms = platforms.unix;
    badPlatforms = optionals (cudaSupport || openclSupport) lib.platforms.darwin;
    broken = (metalSupport && !effectiveStdenv.hostPlatform.isDarwin);
  };
})
