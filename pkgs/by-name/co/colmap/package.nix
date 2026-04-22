{
  lib,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  nix-update-script,
  cmake,
  boost,
  ceres-solver,
  eigen,
  openimageio,
  glog,
  libGLU,
  glew,
  flann,
  cgal,
  gmp,
  mpfr,
  suitesparse,
  onnxruntime,
  poselib,
  lz4,
  autoAddDriverRunpath,
  config,
  stdenv,
  qt5,
  libsm,
  cudaSupport ? config.cudaSupport,
  cudaCapabilities ? cudaPackages.flags.cudaCapabilities,
  cudaPackages,
  faiss,
  sqlite,
  llvmPackages,
  gtest,
  curl,

  enableTests ? true,
}:

assert cudaSupport -> cudaPackages != { };

let
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;

  depsAlsoForPycolmap = [
    boost
    eigen
    ceres-solver
    openimageio
    glog
    libGLU
    glew
    cgal
    poselib
    faiss
    sqlite
    gmp
    mpfr
    lz4
    qt5.qtbase
    suitesparse
    onnxruntime
  ]
  ++ lib.optionals cudaSupport [
    cudatoolkit
    (lib.getOutput "static" cudaPackages.cuda_cudart)
  ]
  ++ lib.optional stdenv'.cc.isClang llvmPackages.openmp;

  # TODO: migrate to redist packages
  inherit (cudaPackages) cudatoolkit;

  # COLMAP needs these model files to run the ONNX tests
  # Based on: https://github.com/colmap/colmap/blob/79efc74b2b614935a3c69b1f983f2bad23a836a1/src/colmap/feature/resources.h#L36
  modelsForTesting = [
    {
      name = "aliked-n16rot.onnx";
      url = "https://github.com/colmap/colmap/releases/download/3.13.0/aliked-n16rot.onnx";
      sha256 = "39c423d0a6f03d39ec89d3d1d61853765c2fb6a8b8381376c703e5758778a547";
    }
    {
      name = "aliked-n32.onnx";
      url = "https://github.com/colmap/colmap/releases/download/3.13.0/aliked-n32.onnx";
      sha256 = "a077728a02d2de1a775c66df6de8cfeb7c6b51ca57572c64c680131c988c8b3c";
    }
    {
      name = "aliked-lightglue.onnx";
      url = "https://github.com/colmap/colmap/releases/download/3.13.0/aliked-lightglue.onnx";
      sha256 = "b9a5de7204648b18a8cf5dcac819f9d30de1a5961ef03756803c8b86c2dceb8d";
    }
    {
      name = "bruteforce-matcher.onnx";
      url = "https://github.com/colmap/colmap/releases/download/3.13.0/bruteforce-matcher.onnx";
      sha256 = "3c1282f96d83f5ffc861a873298d08bbe5219f59af59223f5ceab5c41a182a47";
    }
    {
      name = "sift-lightglue.onnx";
      url = "https://github.com/colmap/colmap/releases/download/3.13.0/sift-lightglue.onnx";
      sha256 = "e0500228472b43f92b3d36881a09b3310d3b058b56187b246cc7b9ab6429096e";
    }
  ];
in
stdenv'.mkDerivation {
  version = "4.0.3";
  pname = "colmap";
  src = fetchFromGitHub {
    owner = "colmap";
    repo = "colmap";
    rev = "e5b4a3e2276fe0cb81c3643d8ffdf124020c372e";
    hash = "sha256-VV+ROjhrg7bEMV3QU6r4zCcMzC7tAPwTu6gV6/cmiH0=";
  };

  cmakeFlags = [
    (lib.cmakeBool "DOWNLOAD_ENABLED" true) # We want COLMAP to be able to fetch models like LightGlue.
    (lib.cmakeBool "UNINSTALL_ENABLED" false)
    (lib.cmakeBool "FETCH_POSELIB" false)
    (lib.cmakeBool "FETCH_FAISS" false)
    (lib.cmakeBool "FETCH_ONNX" false)
    (lib.cmakeBool "TESTS_ENABLED" enableTests)
    (lib.cmakeFeature "CHOLMOD_INCLUDE_DIR_HINTS" "${suitesparse.dev}/include")
    (lib.cmakeFeature "CHOLMOD_LIBRARY_DIR_HINTS" "${suitesparse}/lib")
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeBool "CUDA_ENABLED" cudaSupport)
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" (
      lib.strings.concatStringsSep ";" (map cudaPackages.flags.dropDots cudaCapabilities)
    ))
  ];

  buildInputs = [
    boost
    ceres-solver
    eigen
    openimageio
    glog
    libGLU
    glew
    qt5.qtbase
    flann
    lz4
    cgal
    gmp
    mpfr
    libsm
    curl
  ]
  ++ depsAlsoForPycolmap;

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
    gtest
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
  ];

  doCheck = enableTests;
  preCheck = lib.optionalString enableTests ''
    export GTEST_FILTER='-*Gpu*:*GPU*:*OpenGL*' # Disable any test involving OpenGL or GPU, these won't work in the sandbox.
    export HOME=$PWD
    # Pre-fetch the ONNX models into COLMAP's cache dir so we can run their tests.
    mkdir -p .cache/colmap
    ${lib.concatMapStringsSep "\n" (model: ''
      ln -s ${fetchurl model} .cache/colmap/${model.sha256}-${model.name}
    '') modelsForTesting}
  '';

  passthru.depsAlsoForPycolmap = depsAlsoForPycolmap;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Structure-From-Motion and Multi-View Stereo pipeline";
    longDescription = ''
      COLMAP is a general-purpose Structure-from-Motion (SfM) and Multi-View Stereo (MVS) pipeline
      with a graphical and command-line interface.
    '';
    mainProgram = "colmap";
    homepage = "https://colmap.github.io/index.html";
    license = lib.licenses.bsd3;
    platforms = if cudaSupport then lib.platforms.linux else lib.platforms.unix;
    maintainers = with lib.maintainers; [
      lebastr
      usertam
      chpatrick
    ];
  };
}
