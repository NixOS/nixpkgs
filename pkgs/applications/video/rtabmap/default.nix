{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  opencv,
  pcl,
  libusb1,
  eigen,
  wrapQtAppsHook,
  qtbase,
  g2o,
  ceres-solver,
  zed-open-capture,
  hidapi,
  octomap,
  freenect,
  libdc1394,
  libGL,
  libGLU,
  vtkWithQt5,
  wrapGAppsHook3,
  liblapack,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "rtabmap";
  version = "0.21.4.1";

  src = fetchFromGitHub {
    owner = "introlab";
    repo = "rtabmap";
    rev = "refs/tags/${version}";
    hash = "sha256-y/p1uFSxVQNXO383DLGCg4eWW7iu1esqpWlyPMF3huk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    wrapGAppsHook3
  ];
  buildInputs = [
    ## Required
    opencv
    opencv.cxxdev
    pcl
    liblapack
    xorg.libSM
    xorg.libICE
    xorg.libXt
    ## Optional
    libusb1
    eigen
    g2o
    ceres-solver
    # libpointmatcher - ABI mismatch
    octomap
    freenect
    libdc1394
    # librealsense - missing includedir
    qtbase
    libGL
    libGLU
    vtkWithQt5
    zed-open-capture
    hidapi
  ];

  # Disable warnings that are irrelevant to us as packagers
  cmakeFlags = [ "-Wno-dev" ];

  meta = with lib; {
    description = "Real-Time Appearance-Based 3D Mapping";
    homepage = "https://introlab.github.io/rtabmap/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marius851000 ];
    platforms = with platforms; linux;
  };
}
