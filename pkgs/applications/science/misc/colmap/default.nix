{
  lib,
  fetchFromGitHub,
  cmake,
  boost,
  ceres-solver,
  eigen,
  freeimage,
  glog,
  libGLU,
  glew,
  qtbase,
  flann,
  cgal,
  gmp,
  mpfr,
  autoAddDriverRunpath,
  config,
  stdenv,
  qt5,
  xorg,
  cudaSupport ? config.cudaSupport,
  cudaCapabilities ? cudaPackages.flags.cudaCapabilities,
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
  version = "3.9.1";
  pname = "colmap";
  src = fetchFromGitHub {
    owner = "colmap";
    repo = "colmap";
    rev = version;
    hash = "sha256-Xb4JOttCMERwPYs5DyGKHw+f9Wik1/rdJQKbgVuygH8=";
  };

  cmakeFlags = lib.optionals cudaSupport [
    (lib.cmakeBool "CUDA_ENABLED" true)
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" (
      lib.strings.concatStringsSep ";" (map cudaPackages.flags.dropDots cudaCapabilities)
    ))
  ];

  buildInputs = [
    boost_static
    ceres-solver
    eigen
    freeimage
    glog
    libGLU
    glew
    qtbase
    flann
    cgal
    gmp
    mpfr
    xorg.libSM
  ]
  ++ lib.optionals cudaSupport [
    cudatoolkit
    cudaPackages.cuda_cudart.static
  ];

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
  ];

  meta = with lib; {
    description = "Structure-From-Motion and Multi-View Stereo pipeline";
    longDescription = ''
      COLMAP is a general-purpose Structure-from-Motion (SfM) and Multi-View Stereo (MVS) pipeline
      with a graphical and command-line interface.
    '';
    homepage = "https://colmap.github.io/index.html";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lebastr ];
  };
}
