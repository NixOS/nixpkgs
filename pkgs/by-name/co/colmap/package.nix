{
  lib,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
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
in
stdenv'.mkDerivation {
  version = "4.0.2";
  pname = "colmap";
  src = fetchFromGitHub {
    owner = "colmap";
    repo = "colmap";
    rev = "d927f7e518fc20afa33390712c4cc20d85b730b8";
    hash = "sha256-+cPkksfCLyEo7A70nuRWnOBEkhx8BFevQ9XWTipEkpM=";
  };

  patches = [
    ./suitesparse-no-include-subdir.patch
    # Remove when https://github.com/colmap/colmap/pull/4265 is merged
    ./disambiguate-gradientchecker.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "DOWNLOAD_ENABLED" false)
    (lib.cmakeBool "UNINSTALL_ENABLED" false)
    (lib.cmakeBool "FETCH_POSELIB" false)
    (lib.cmakeBool "FETCH_FAISS" false)
    (lib.cmakeBool "FETCH_ONNX" false)
    (lib.cmakeBool "TESTS_ENABLED" true)
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

  passthru.depsAlsoForPycolmap = depsAlsoForPycolmap;

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
