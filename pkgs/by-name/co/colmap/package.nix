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
  cudaCapabilities ? cudaPackages.cudaFlags.cudaCapabilities,
  cudaPackages,
}:

assert cudaSupport -> cudaPackages != { };

let
  boost_static = boost.override { enableStatic = true; };
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;

  # TODO: migrate to redist packages
  inherit (cudaPackages) cudatoolkit;
in
stdenv'.mkDerivation rec {
  version = "3.11.1";
  pname = "colmap";
  src = fetchFromGitHub {
    owner = "colmap";
    repo = "colmap";
    rev = version;
    hash = "sha256-xtA0lEAq38/AHI3C9FhvjV5JPfVawrFr1fga4J1pi/0=";
  };

  patches = [
    ./0001-lib-PoissonRecon-fix-build-with-clang-19.patch
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "FETCH_POSELIB" false)
    ]
    ++ lib.optionals cudaSupport [
      (lib.cmakeBool "CUDA_ENABLED" true)
      (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" (
        lib.strings.concatStringsSep ";" (map cudaPackages.cudaFlags.dropDot cudaCapabilities)
      ))
    ];

  buildInputs =
    [
      boost_static
      ceres-solver
      eigen
      freeimage
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
      poselib
    ]
    ++ lib.optionals cudaSupport [
      cudatoolkit
      cudaPackages.cuda_cudart.static
    ];

  nativeBuildInputs =
    [
      cmake
      qt5.wrapQtAppsHook
    ]
    ++ lib.optionals cudaSupport [
      autoAddDriverRunpath
    ];

  enableParallelBuilding = true;
  enableParallelInstalling = true;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "COLMAP - Structure-From-Motion and Multi-View Stereo pipeline";
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
