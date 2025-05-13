{
  lib,
  config,
  fetchFromGitHub,
  cmake,
  cctools,
  llvmPackages,
  ninja,
  openssl,
  python3,
  ragel,
  yasm,
  zlib,
  gitUpdater,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  llvmPackagesCuda ? llvmPackages,
  pythonSupport ? false,
}:
let
  stdenv = if cudaSupport then cudaPackages.backendStdenv else llvmPackages.stdenv;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "catboost";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "catboost";
    repo = "catboost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TsBob9vxFqE4HxuvEpjIbyc3deOpU+gDl4ysn6I+DNY=";
  };

  postPatch = ''
    substituteInPlace cmake/common.cmake \
      --replace-fail  "\''${RAGEL_BIN}" "${ragel}/bin/ragel" \
      --replace-fail "\''${YASM_BIN}" "${yasm}/bin/yasm"

    shopt -s globstar
    for cmakelists in **/CMakeLists.*; do
      sed -i "s/openssl::openssl/OpenSSL::SSL/g" $cmakelists
      ${lib.optionalString (cudaPackages.cudaOlder "11.8") ''
        sed -i 's/-gencode=arch=compute_89,code=sm_89//g' $cmakelists
        sed -i 's/-gencode=arch=compute_90,code=sm_90//g' $cmakelists
      ''}
    done
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs =
    [
      cmake
      llvmPackages.bintools
      ninja
      python3
      ragel
      yasm
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
    ]
    ++ lib.optionals pythonSupport [
      (python3.withPackages (
        ps: with ps; [
          cython
          numpy
        ]
      ))
    ];

  buildInputs =
    [
      openssl
      zlib
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cudart
      cudaPackages.cuda_cccl
      cudaPackages.libcublas
    ];

  env = {
    PROGRAM_VERSION = finalAttrs.version;

    # catboost requires clang 14+ for build, but does clang 12 for cuda build.
    # after bumping the default version of llvm, check for compatibility with the cuda backend and pin it.
    # see https://catboost.ai/en/docs/installation/build-environment-setup-for-cmake#compilers,-linkers-and-related-tools
    CUDAHOSTCXX = lib.optionalString cudaSupport "${llvmPackagesCuda.stdenv.cc}/bin/cc";
    NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isLinux "-fuse-ld=lld";
    NIX_LDFLAGS = "-lc -lm";
    NIX_CFLAGS_COMPILE = toString (
      lib.optionals stdenv.cc.isClang [
        "-Wno-error=missing-template-arg-list-after-template-kw"
      ]
    );
  };

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BINARY_DIR" "$out")
    (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" true)
    (lib.cmakeFeature "CATBOOST_COMPONENTS" "app;libs${lib.optionalString pythonSupport ";python-package"}")
    (lib.cmakeBool "HAVE_CUDA" cudaSupport)
  ];

  installPhase = ''
    runHook preInstall

    mkdir $dev
    cp -r catboost $dev
    install -Dm555 catboost/app/catboost -t $out/bin
    install -Dm444 catboost/libs/model_interface/static/lib/libmodel_interface-static-lib.a -t $out/lib
    install -Dm444 catboost/libs/model_interface/libcatboostmodel${stdenv.hostPlatform.extensions.sharedLibrary} -t $out/lib
    install -Dm444 catboost/libs/train_interface/libcatboost${stdenv.hostPlatform.extensions.sharedLibrary} -t $out/lib

    runHook postInstall
  '';

  passthru = {
    tests = {
      python = python3.pkgs.catboost;
    };
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "High-performance library for gradient boosting on decision trees";
    longDescription = ''
      A fast, scalable, high performance Gradient Boosting on Decision Trees
      library, used for ranking, classification, regression and other machine
      learning tasks for Python, R, Java, C++. Supports computation on CPU and GPU.
    '';
    changelog = "https://github.com/catboost/catboost/blob/${finalAttrs.src.tag}/RELEASE.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    homepage = "https://catboost.ai";
    maintainers = with lib.maintainers; [
      PlushBeaver
      natsukium
    ];
    mainProgram = "catboost";
    # /nix/store/hzxiynjmmj35fpy3jla7vcqwmzj9i449-Libsystem-1238.60.2/include/sys/_types/_mbstate_t.h:31:9: error: unknown type name '__darwin_mbstate_t'
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
})
