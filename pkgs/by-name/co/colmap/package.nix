{
  lib,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  cmake,
  boost,
  ceres-solver,
  eigen,
  freeimage,
  glog,
  libGLU,
  glew,
  cgal,
  gmp,
  mpfr,
  poselib,
  sqlite,
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
  llvmPackages,
  gtest,
}:

assert cudaSupport -> cudaPackages != { };

let
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;

  # These deps are also needed by pycolmap.
  pythonDeps = [
    boost
    eigen
    ceres-solver
    freeimage
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
stdenv'.mkDerivation rec {
  version = "3.12.5";
  pname = "colmap";
  src = fetchFromGitHub {
    owner = "colmap";
    repo = "colmap";
    rev = version;
    hash = "sha256-ngmEYCLeCh5pSNmXItV3siY6/DupEHK+dYZ56LWZbhg=";
  };

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
    xorg.libSM
  ]
  ++ pythonDeps;

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
    gtest
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
  ];

  passthru.updateScript = gitUpdater { };
  passthru.pythonDeps = pythonDeps;

  meta = with lib; {
    description = "Structure-From-Motion and Multi-View Stereo pipeline";
    longDescription = ''
      COLMAP is a general-purpose Structure-from-Motion (SfM) and Multi-View Stereo (MVS) pipeline
      with a graphical and command-line interface.
    '';
    mainProgram = "colmap";
    homepage = "https://colmap.github.io/index.html";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      lebastr
      usertam
    ];
  };
}
