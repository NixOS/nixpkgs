{
  lib,
  stdenv,
  config,
  fetchFromGitHub,
  cmake,
  llvmPackages, # openmp
  withMkl ? false,
  mkl,
  withCUDA ? config.cudaSupport,
  withCuDNN ? withCUDA && (cudaPackages ? cudnn),
  cudaPackages,
  # Enabling both withOneDNN and withOpenblas is broken
  # https://github.com/OpenNMT/CTranslate2/issues/1294
  withOneDNN ? false,
  oneDNN,
  withOpenblas ? true,
  openblas,
  withRuy ? true,

  # passthru tests
  libretranslate,
  wyoming-faster-whisper,
}:

let
  stdenv' = if withCUDA then cudaPackages.backendStdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "ctranslate2";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "OpenNMT";
    repo = "CTranslate2";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-EM2kunqtxo0BTIzrEomfaRsdav7sx6QEOhjDtjjSoYY=";
  };

  # Fix CMake 4 compatibility
  postPatch = ''
    substituteInPlace third_party/cpu_features/CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.0)' \
        'cmake_minimum_required(VERSION 3.10)'

    substituteInPlace third_party/ruy/third_party/cpuinfo/deps/clog/CMakeLists.txt \
      --replace-fail \
        'CMAKE_MINIMUM_REQUIRED(VERSION 3.1 FATAL_ERROR)' \
        'CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)'
  '';

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals withCUDA [
    cudaPackages.cuda_nvcc
  ];

  cmakeFlags = [
    # https://opennmt.net/CTranslate2/installation.html#build-options
    # https://github.com/OpenNMT/CTranslate2/blob/54810350e662ebdb01ecbf8e4a746f02aeff1dd7/python/tools/prepare_build_environment_linux.sh#L53
    # https://github.com/OpenNMT/CTranslate2/blob/59d223abcc7e636c1c2956e62482bc3299cc7766/python/tools/prepare_build_environment_macos.sh#L12
    (lib.cmakeFeature "OPENMP_RUNTIME" "COMP")
    (lib.cmakeBool "WITH_CUDA" withCUDA)
    (lib.cmakeBool "WITH_CUDNN" withCuDNN)
    (lib.cmakeBool "WITH_DNNL" withOneDNN)
    (lib.cmakeBool "WITH_OPENBLAS" withOpenblas)
    (lib.cmakeBool "WITH_RUY" withRuy)
    (lib.cmakeBool "WITH_MKL" withMkl)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "WITH_ACCELERATE" true)
  ];

  buildInputs =
    lib.optionals withMkl [
      mkl
    ]
    ++ lib.optionals withCUDA [
      cudaPackages.cuda_cccl # <nv/target> required by the fp16 headers in cudart
      cudaPackages.cuda_cudart
      cudaPackages.libcublas
      cudaPackages.libcurand
    ]
    ++ lib.optionals (withCUDA && withCuDNN) [
      cudaPackages.cudnn
    ]
    ++ lib.optionals withOneDNN [
      oneDNN
    ]
    ++ lib.optionals withOpenblas [
      openblas
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      llvmPackages.openmp
    ];

  passthru.tests = {
    inherit
      libretranslate
      wyoming-faster-whisper
      ;
  };

  meta = {
    description = "Fast inference engine for Transformer models";
    mainProgram = "ct2-translator";
    homepage = "https://github.com/OpenNMT/CTranslate2";
    changelog = "https://github.com/OpenNMT/CTranslate2/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hexa
      misuzu
    ];
    broken = !(withCuDNN -> withCUDA);
  };
})
