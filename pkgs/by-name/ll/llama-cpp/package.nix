{ lib
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
, pkg-config
, metalSupport ? stdenv.isDarwin && stdenv.isAarch64 && !openclSupport
, vulkanSupport ? false
, mpiSupport ? false # Increases the runtime closure by ~700M
, vulkan-headers
, vulkan-loader
, ninja
, git
, mpi
}:

let
  # It's necessary to consistently use backendStdenv when building with CUDA support,
  # otherwise we get libstdc++ errors downstream.
  # cuda imposes an upper bound on the gcc version, e.g. the latest gcc compatible with cudaPackages_11 is gcc11
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
  inherit (lib) cmakeBool cmakeFeature optionals;

  darwinBuildInputs =
    with darwin.apple_sdk.frameworks;
    [
      Accelerate
      CoreVideo
      CoreGraphics
    ]
    ++ optionals metalSupport [ MetalKit ];

   cudaBuildInputs = with cudaPackages; [
    cuda_cccl.dev # <nv/target>

    # A temporary hack for reducing the closure size, remove once cudaPackages
    # have stopped using lndir: https://github.com/NixOS/nixpkgs/issues/271792
    cuda_cudart.dev
    cuda_cudart.lib
    cuda_cudart.static
    libcublas.dev
    libcublas.lib
    libcublas.static
  ];

  rocmBuildInputs = with rocmPackages; [
    clr
    hipblas
    rocblas
  ];

  vulkanBuildInputs = [
    vulkan-headers
    vulkan-loader
  ];
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "llama-cpp";
  version = "2481";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "llama.cpp";
    rev = "refs/tags/b${finalAttrs.version}";
    hash = "sha256-40GSZZEnjM9L9KVVKdSKtBoSRy996l98ORM4NeltsSM=";
  };

  postPatch = ''
    substituteInPlace ./ggml-metal.m \
      --replace '[bundle pathForResource:@"ggml-metal" ofType:@"metal"];' "@\"$out/bin/ggml-metal.metal\";"
  '';

  nativeBuildInputs = [ cmake ninja pkg-config git ]
    ++ optionals cudaSupport [
    cudaPackages.cuda_nvcc
    cudaPackages.autoAddDriverRunpath
  ];

  buildInputs = optionals effectiveStdenv.isDarwin darwinBuildInputs
    ++ optionals cudaSupport cudaBuildInputs
    ++ optionals mpiSupport mpi
    ++ optionals openclSupport [ clblast ]
    ++ optionals rocmSupport rocmBuildInputs
    ++ optionals vulkanSupport vulkanBuildInputs;

  cmakeFlags = [
    # -march=native is non-deterministic; override with platform-specific flags if needed
    (cmakeBool "LLAMA_NATIVE" false)
    (cmakeBool "BUILD_SHARED_SERVER" true)
    (cmakeBool "BUILD_SHARED_LIBS" true)
    (cmakeBool "BUILD_SHARED_LIBS" true)
    (cmakeBool "LLAMA_BLAS" blasSupport)
    (cmakeBool "LLAMA_CLBLAST" openclSupport)
    (cmakeBool "LLAMA_CUBLAS" cudaSupport)
    (cmakeBool "LLAMA_HIPBLAS" rocmSupport)
    (cmakeBool "LLAMA_METAL" metalSupport)
    (cmakeBool "LLAMA_MPI" mpiSupport)
    (cmakeBool "LLAMA_VULKAN" vulkanSupport)
  ]
      ++ optionals cudaSupport [
        (
          with cudaPackages.flags;
          cmakeFeature "CMAKE_CUDA_ARCHITECTURES" (
            builtins.concatStringsSep ";" (map dropDot cudaCapabilities)
          )
        )
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
      ++ optionals metalSupport [ (cmakeFeature "CMAKE_C_FLAGS" "-D__ARM_FEATURE_DOTPROD=1") ]
      ++ optionals blasSupport [ (cmakeFeature "LLAMA_BLAS_VENDOR" "OpenBLAS") ];

  # upstream plans on adding targets at the cmakelevel, remove those
  # additional steps after that
  postInstall = ''
    mv $out/bin/main $out/bin/llama
    mv $out/bin/server $out/bin/llama-server
    mkdir -p $out/include
    cp $src/llama.h $out/include/
  '';

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
