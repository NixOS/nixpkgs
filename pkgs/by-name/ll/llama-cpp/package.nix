{ lib
, autoAddDriverRunpath
, cmake
, darwin
, fetchFromGitHub
, nix-update-script
, stdenv

, config
, cudaSupport ? config.cudaSupport
, cudaPackages ? { }

, rocmSupport ? config.rocmSupport
, rocmPackages ? { }

, openclSupport ? false
, clblast

, blasSupport ? builtins.all (x: !x) [ cudaSupport metalSupport openclSupport rocmSupport vulkanSupport ]
, blas

, pkg-config
, metalSupport ? stdenv.isDarwin && stdenv.isAarch64 && !openclSupport
, vulkanSupport ? false
, rpcSupport ? false
, shaderc
, vulkan-headers
, vulkan-loader
, ninja
, git
}:

let
  # It's necessary to consistently use backendStdenv when building with CUDA support,
  # otherwise we get libstdc++ errors downstream.
  # cuda imposes an upper bound on the gcc version, e.g. the latest gcc compatible with cudaPackages_11 is gcc11
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
  inherit (lib) cmakeBool cmakeFeature optionals optionalString;

  darwinBuildInputs =
    with darwin.apple_sdk.frameworks;
    [
      Accelerate
      CoreVideo
      CoreGraphics
    ]
    ++ optionals metalSupport [ MetalKit ];

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
  version = "3565";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "llama.cpp";
    rev = "refs/tags/b${finalAttrs.version}";
    hash = "sha256-eAsChIG30Oj5aFQyFDtyWqqT2PTgmdJ2jSrsi2UH+Gc=";
    leaveDotGit = true;
    postFetch = ''
      git -C "$out" rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  postPatch = ''
    substituteInPlace ./ggml/src/ggml-metal.m \
      --replace-fail '[bundle pathForResource:@"ggml-metal" ofType:@"metal"];' "@\"$out/bin/ggml-metal.metal\";"

    substituteInPlace ./scripts/build-info.sh \
      --replace-fail 'build_number="0"' 'build_number="${finalAttrs.version}"' \
      --replace-fail 'build_commit="unknown"' "build_commit=\"$(cat COMMIT)\""
  '';

  nativeBuildInputs = [ cmake ninja pkg-config git ]
    ++ optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];

  buildInputs = optionals effectiveStdenv.isDarwin darwinBuildInputs
    ++ optionals cudaSupport cudaBuildInputs
    ++ optionals openclSupport [ clblast ]
    ++ optionals rocmSupport rocmBuildInputs
    ++ optionals blasSupport [ blas ]
    ++ optionals vulkanSupport vulkanBuildInputs;

  cmakeFlags = [
    # -march=native is non-deterministic; override with platform-specific flags if needed
    (cmakeBool "GGML_NATIVE" false)
    (cmakeBool "LLAMA_BUILD_SERVER" true)
    (cmakeBool "BUILD_SHARED_LIBS" true)
    (cmakeBool "GGML_BLAS" blasSupport)
    (cmakeBool "GGML_CLBLAST" openclSupport)
    (cmakeBool "GGML_CUDA" cudaSupport)
    (cmakeBool "GGML_HIPBLAS" rocmSupport)
    (cmakeBool "GGML_METAL" metalSupport)
    (cmakeBool "GGML_RPC" rpcSupport)
    (cmakeBool "GGML_VULKAN" vulkanSupport)
  ]
      ++ optionals cudaSupport [
        (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
      ]
      ++ optionals rocmSupport [
        (cmakeFeature "CMAKE_C_COMPILER" "hipcc")
        (cmakeFeature "CMAKE_CXX_COMPILER" "hipcc")

        # Build all targets supported by rocBLAS. When updating search for TARGET_LIST_ROCM
        # in https://github.com/ROCmSoftwarePlatform/rocBLAS/blob/develop/CMakeLists.txt
        # and select the line that matches the current nixpkgs version of rocBLAS.
        # Should likely use `rocmPackages.clr.gpuTargets`.
        "-DAMDGPU_TARGETS=gfx803;gfx900;gfx906:xnack-;gfx908:xnack-;gfx90a:xnack+;gfx90a:xnack-;gfx940;gfx941;gfx942;gfx1010;gfx1012;gfx1030;gfx1100;gfx1101;gfx1102"
      ]
      ++ optionals metalSupport [
        (cmakeFeature "CMAKE_C_FLAGS" "-D__ARM_FEATURE_DOTPROD=1")
        (cmakeBool "LLAMA_METAL_EMBED_LIBRARY" true)
      ] ++ optionals rpcSupport [
        # This is done so we can move rpc-server out of bin because llama.cpp doesn't
        # install rpc-server in their install target.
        "-DCMAKE_SKIP_BUILD_RPATH=ON"
      ];

  # upstream plans on adding targets at the cmakelevel, remove those
  # additional steps after that
  postInstall = ''
    # Match previous binary name for this package
    ln -sf $out/bin/llama-cli $out/bin/llama

    mkdir -p $out/include
    cp $src/include/llama.h $out/include/
  '' + optionalString rpcSupport "cp bin/rpc-server $out/bin/llama-rpc-server";

  passthru.updateScript = nix-update-script {
    attrPath = "llama-cpp";
    extraArgs = [ "--version-regex" "b(.*)" ];
  };

  meta = with lib; {
    description = "Port of Facebook's LLaMA model in C/C++";
    homepage = "https://github.com/ggerganov/llama.cpp/";
    license = licenses.mit;
    mainProgram = "llama";
    maintainers = with maintainers; [ dit7ya elohmeier philiptaron ];
    platforms = platforms.unix;
    badPlatforms = optionals (cudaSupport || openclSupport) lib.platforms.darwin;
    broken = (metalSupport && !effectiveStdenv.isDarwin);
  };
})
