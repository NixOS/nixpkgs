{
  stdenv,
  apple-sdk,
  boost,
  clangStdenv,
  cmake,
  config,
  cudaPackages,
  eigen,
  fetchFromGitHub,
  gperftools,
  lib,
  libzip,
  makeWrapper,
  ninja,
  ocl-icd,
  opencl-headers,
  openssl,
  protobuf,
  writeShellScriptBin,
  enableAVX2 ? stdenv.hostPlatform.avx2Support,
  backend ? if config.cudaSupport then "cuda" else "opencl",
  enableBigBoards ? false,
  enableContrib ? false,
  enableTcmalloc ? true,
  enableTrtPlanCache ? false,
}:

assert lib.assertOneOf "backend" backend [
  "opencl"
  "cuda"
  "tensorrt"
  "eigen"
  "metal"
];

# Metal is only permitted on MacOS
assert stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 || backend != "metal";

# The TensorRT Plan Cache is only applicable to the trt backend
assert !(enableTrtPlanCache && backend != "tensorrt");

# cannot enable both TrtPlanCache and Contrib simultaneously, this is checked by CMake
assert !(enableTrtPlanCache && enableContrib);

let
  githash = "5246793f77b480dee91a3b92902d1a9b92860bd0";
  fakegit = writeShellScriptBin "git" "echo ${githash}";
  stdenv' =
    if
      builtins.elem backend [
        "cuda"
        "tensorrt"
      ]
    then
      cudaPackages.backendStdenv
    else if backend == "metal" then
      clangStdenv
    else
      stdenv;
in
stdenv'.mkDerivation rec {
  pname = "katago";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "lightvector";
    repo = "katago";
    rev = "v${version}";
    sha256 = "sha256-mnsfl/HNrrQiKIBV3dzb3AVFDPf0q3DSl/QG5tzasmA=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    libzip
    boost
  ]
  ++ lib.optionals (backend == "eigen") [ eigen ]
  ++ lib.optionals (backend == "cuda") (
    with cudaPackages;
    [
      cuda_cudart
      cuda_nvrtc
      cudnn
      libcublas
    ]
  )
  ++ lib.optionals (backend == "tensorrt") (
    with cudaPackages;
    [
      cuda_cudart
      tensorrt
      protobuf
    ]
  )
  ++ lib.optionals (backend == "opencl") [
    ocl-icd
    opencl-headers
  ]
  ++ lib.optionals (backend == "metal") [
    apple-sdk
    ninja
  ]
  ++ lib.optionals enableContrib [ openssl ]
  ++ lib.optionals enableTcmalloc [ gperftools ];

  cmakeFlags = [
    (lib.cmakeFeature "USE_BACKEND" (lib.toUpper backend))
    (lib.cmakeBool "USE_AVX2" enableAVX2)
    (lib.cmakeBool "USE_TCMALLOC" enableTcmalloc)
    (lib.cmakeBool "USE_BIGGER_BOARDS_EXPENSIVE" enableBigBoards)
    (lib.cmakeBool "USE_CACHE_TENSORRT_PLAN" enableTrtPlanCache)
    (lib.cmakeBool "NO_GIT_REVISION" (!enableContrib))
  ]
  ++ lib.optionals enableContrib [
    (lib.cmakeBool "BUILD_DISTRIBUTED" true)
    (lib.cmakeFeature "GIT_EXECUTABLE" "${fakegit}/bin/git")
  ]
  ++ lib.optionals (backend == "metal") [
    "-GNinja"
  ];

  preConfigure = ''
    cd cpp/
  ''
  + lib.optionalString (backend == "cuda" || backend == "tensorrt") ''
    export CUDA_PATH="${cudaPackages.cuda_nvcc}"
    export EXTRA_LDFLAGS="-L/run/opengl-driver/lib"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin; cp katago $out/bin;
  ''
  + lib.optionalString (backend == "cuda" || backend == "tensorrt") ''
    wrapProgram $out/bin/katago \
      --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
  ''
  + ''
    runHook postInstall
  '';

  meta = with lib; {
    description = "Go engine modeled after AlphaGo Zero";
    mainProgram = "katago";
    homepage = "https://github.com/lightvector/katago";
    license = licenses.mit;
    maintainers = [ maintainers.omnipotententity ];
    platforms = platforms.unix;
  };
}
