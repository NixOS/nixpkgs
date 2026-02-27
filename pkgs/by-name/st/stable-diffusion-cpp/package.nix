{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  python3,
  autoAddDriverRunpath,

  config ? { },

  cudaSupport ? (config.cudaSupport or false),
  cudaPackages ? { },

  rocmSupport ? (config.rocmSupport or false),
  rocmPackages ? { },
  rocmGpuTargets ? (rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets or [ ]),

  openclSupport ? false,
  clblast,
  vulkanSupport ? false,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  spirv-tools,

  metalSupport ? (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64),
  darwin,
  apple-sdk,
}:

let
  inherit (lib)
    cmakeBool
    cmakeFeature
    optionals
    optionalString
    ;

  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "stable-diffusion-cpp";
  version = "master-492-f957fa3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "leejet";
    repo = "stable-diffusion.cpp";
    rev = "master-492-f957fa3";
    hash = "sha256-qY21TfU5t5KdD59Q9LoMHxD1AGQKhH/fr5NLRdyeF7k=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ]
  ++ optionals cudaSupport [
    (cudaPackages.cuda_nvcc)
    autoAddDriverRunpath
  ];

  buildInputs =
    (optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cccl
        cuda_cudart
        libcublas
      ]
    ))
    ++ (optionals rocmSupport (
      with rocmPackages;
      [
        clr
        hipblas
        rocblas
      ]
    ))
    ++ (optionals vulkanSupport [
      shaderc
      vulkan-headers
      vulkan-loader
      spirv-tools
    ])
    ++ (optionals openclSupport [
      clblast
    ])
    ++ (optionals metalSupport [
      apple-sdk
    ]);

  cmakeFlags = [
    (cmakeBool "SD_BUILD_EXAMPLES" true)
    (cmakeBool "SD_BUILD_SHARED_LIBS" true)
    (cmakeBool "SD_USE_SYSTEM_GGML" false)
    (cmakeBool "SD_CUDA" cudaSupport)
    (cmakeBool "SD_HIPBLAS" rocmSupport)
    (cmakeBool "SD_VULKAN" vulkanSupport)
    (cmakeBool "SD_OPENCL" openclSupport)
    (cmakeBool "SD_METAL" metalSupport)
    (cmakeBool "SD_FAST_SOFTMAX" false)
  ]
  ++ optionals cudaSupport [
    (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ]
  ++ optionals rocmSupport [
    (cmakeFeature "CMAKE_HIP_ARCHITECTURES" (builtins.concatStringsSep ";" rocmGpuTargets))
  ];

  meta = {
    description = "Stable Diffusion inference in pure C/C++";
    homepage = "https://github.com/leejet/stable-diffusion.cpp";
    license = lib.licenses.mit;
    mainProgram = "sd";
    maintainers = with lib.maintainers; [
      dit7ya
      adriangl
    ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.optionals (cudaSupport || openclSupport) lib.platforms.darwin;
    broken = metalSupport && !stdenv.hostPlatform.isDarwin;
  };
})
