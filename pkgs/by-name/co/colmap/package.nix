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
  poselib,
  lz4,
  autoAddDriverRunpath,
  config,
  stdenv,
  qt5,
  xorg,
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
  ]
  ++ lib.optionals cudaSupport [
    cudatoolkit
    cudaPackages.cuda_cudart.static
  ]
  ++ lib.optional stdenv'.cc.isClang llvmPackages.openmp;

  # TODO: migrate to redist packages
  inherit (cudaPackages) cudatoolkit;
in
stdenv'.mkDerivation {
  version = "unstable-3.12.5-openimageio";
  pname = "colmap";
  src = fetchFromGitHub {
    owner = "colmap";
    repo = "colmap";
    rev = "f8edccaa36909713b9d3930e1ca65cb364a38b26";
    hash = "sha256-0lD7ywM48ODe11u9D3XSk9btqQ4gs/APBFf9IyiXe6g=";
  };

  # TODO: remove this when https://github.com/colmap/colmap/pull/3459 is in a release
  # This was produced with:
  # git diff f8edccaa36909713b9d3930e1ca65cb364a38b26 e40c0730020938587c9d4eb7634cbff93cbc2f81
  patches = [ ./openimageio.patch ];

  cmakeFlags = [
    (lib.cmakeBool "DOWNLOAD_ENABLED" false)
    (lib.cmakeBool "UNINSTALL_ENABLED" false)
    (lib.cmakeBool "FETCH_POSELIB" false)
    (lib.cmakeBool "FETCH_FAISS" false)
    (lib.cmakeBool "TESTS_ENABLED" true)
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
    xorg.libSM
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

  meta = with lib; {
    description = "Structure-From-Motion and Multi-View Stereo pipeline";
    longDescription = ''
      COLMAP is a general-purpose Structure-from-Motion (SfM) and Multi-View Stereo (MVS) pipeline
      with a graphical and command-line interface.
    '';
    mainProgram = "colmap";
    homepage = "https://colmap.github.io/index.html";
    license = licenses.bsd3;
    platforms = if cudaSupport then platforms.linux else platforms.unix;
    maintainers = with maintainers; [
      lebastr
      usertam
      chpatrick
    ];
  };
}
