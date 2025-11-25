{
  stdenv,
  boost,
  cmake,
  config,
  cudaPackages,
  eigen,
  fetchFromGitHub,
  gperftools,
  lib,
  libzip,
  makeWrapper,
  ocl-icd,
  opencl-headers,
  openssl,
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
];

# N.b. older versions of cuda toolkit (e.g. 10) do not support newer versions
# of gcc.  If you need to use cuda10, please override stdenv with gcc8Stdenv
let
  githash = "cd0ed6c0712088ddb901be68189ba7fa1439a9e7";
  fakegit = writeShellScriptBin "git" "echo ${githash}";
  stdenv' =
    if
      builtins.elem backend [
        "cuda"
        "tensorrt"
      ]
    then
      cudaPackages.backendStdenv
    else
      stdenv;
in
stdenv'.mkDerivation rec {
  pname = "katago";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "lightvector";
    repo = "katago";
    rev = "v${version}";
    sha256 = "sha256-hZc8LlOxnVqJqyqOSIWKv3550QOaGr79xgqsAQ8B8SM=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  # Included from release 1.16.2:
  # https://github.com/lightvector/KataGo/commit/9030f72d152da42c1dd03590aa5116993ea842f6
  # Doesn't apply cleanly as a patch so doing a quick replacement to the same effect.
  prePatch = lib.optionalString (backend == "tensorrt") ''
    nixLog "patching $PWD/cpp/CMakeLists.txt to work around outdated TensorRT version detection"
    substituteInPlace "$PWD/cpp/CMakeLists.txt" \
      --replace-fail \
        'if(TENSORRT_VERSION VERSION_LESS 8.5)' \
        'if(NOT TENSORRT_VERSION STREQUAL ".." AND TENSORRT_VERSION VERSION_LESS 8.5)'
  '';

  buildInputs = [
    libzip
    boost
  ]
  ++ lib.optionals (backend == "eigen") [ eigen ]
  ++ lib.optionals (backend == "cuda") (
    with cudaPackages;
    [
      cuda_cccl
      cuda_cudart
      cuda_nvcc
      cudnn
      libcublas
    ]
  )
  ++ lib.optionals (backend == "tensorrt") (
    with cudaPackages;
    [
      cuda_cudart
      tensorrt
    ]
  )
  ++ lib.optionals (backend == "opencl") [
    opencl-headers
    ocl-icd
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
    platforms = [ "x86_64-linux" ];
  };
}
