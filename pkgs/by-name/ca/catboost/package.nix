{ lib
, config
, fetchFromGitHub
, cmake
, cctools
, libiconv
, llvmPackages
, ninja
, openssl
, python3Packages
, ragel
, yasm
, zlib
, cudaSupport ? config.cudaSupport
, cudaPackages ? {}
, llvmPackages_12
, pythonSupport ? false
}:
let
  inherit (llvmPackages) stdenv;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "catboost";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "catboost";
    repo = "catboost";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-2dfCCCa0LheytkLRbYuBd25M320f1kbhBWKIVjslor0=";
  };

  patches = [
    ./remove-conan.patch
  ];

  postPatch = ''
    substituteInPlace cmake/common.cmake \
      --replace-fail  "\''${RAGEL_BIN}" "${ragel}/bin/ragel" \
      --replace-fail "\''${YASM_BIN}" "${yasm}/bin/yasm"

    shopt -s globstar
    for cmakelists in **/CMakeLists.*; do
      sed -i "s/OpenSSL::OpenSSL/OpenSSL::SSL/g" $cmakelists
      ${lib.optionalString (lib.versionOlder cudaPackages.cudaVersion "11.8") ''
        sed -i 's/-gencode=arch=compute_89,code=sm_89//g' $cmakelists
        sed -i 's/-gencode=arch=compute_90,code=sm_90//g' $cmakelists
      ''}
    done
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    llvmPackages.bintools
    ninja
    (python3Packages.python.withPackages (ps: with ps; [ six ]))
    ragel
    yasm
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_nvcc
  ]);

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_cudart
    cuda_cccl
    libcublas
  ]);

  env = {
    # catboost requires clang 14+ for build, but does clang 12 for cuda build.
    # after bumping the default version of llvm, check for compatibility with the cuda backend and pin it.
    # see https://catboost.ai/en/docs/installation/build-environment-setup-for-cmake#compilers,-linkers-and-related-tools
    CUDAHOSTCXX = lib.optionalString cudaSupport "${llvmPackages_12.stdenv.cc}/bin/cc";
    NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isLinux "-fuse-ld=lld";
    NIX_LDFLAGS = "-lc -lm";
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

  meta = with lib; {
    description = "High-performance library for gradient boosting on decision trees";
    longDescription = ''
      A fast, scalable, high performance Gradient Boosting on Decision Trees
      library, used for ranking, classification, regression and other machine
      learning tasks for Python, R, Java, C++. Supports computation on CPU and GPU.
    '';
    license = licenses.asl20;
    platforms = platforms.unix;
    homepage = "https://catboost.ai";
    maintainers = with maintainers; [ PlushBeaver natsukium ];
    mainProgram = "catboost";
  };
})
