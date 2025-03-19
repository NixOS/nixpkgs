{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  libsForQt5,
  pkg-config,
  wrapGAppsHook3,

  # buildInputs
  opencv,
  pcl,
  liblapack,
  xorg,
  libusb1,
  eigen,
  g2o,
  ceres-solver,
  octomap,
  freenect,
  libdc1394,
  libGL,
  libGLU,
  vtkWithQt5,
  zed-open-capture,
  hidapi,

  # passthru
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtabmap";
  version = "0.21.4.1";

  src = fetchFromGitHub {
    owner = "introlab";
    repo = "rtabmap";
    tag = finalAttrs.version;
    hash = "sha256-y/p1uFSxVQNXO383DLGCg4eWW7iu1esqpWlyPMF3huk=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    pkg-config
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
    libsForQt5.qtbase
    libGL
    libGLU
    vtkWithQt5
    zed-open-capture
    hidapi
  ];

  # Disable warnings that are irrelevant to us as packagers
  cmakeFlags = [ "-Wno-dev" ];

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Real-Time Appearance-Based 3D Mapping";
    homepage = "https://introlab.github.io/rtabmap/";
    changelog = "https://github.com/introlab/rtabmap/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ marius851000 ];
    platforms = with lib.platforms; linux;
    # pcl/io/io.h: No such file or directory
    broken = true;
  };
})
