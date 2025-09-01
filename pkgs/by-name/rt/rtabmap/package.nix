{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

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
  yaml-cpp,
  libnabo,
  libpointmatcher,
  eigen,
  g2o,
  ceres-solver,
  octomap,
  freenect,
  libdc1394,
  libGL,
  libGLU,
  librealsense,
  vtkWithQt5,
  zed-open-capture,
  hidapi,

  # passthru
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtabmap";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "introlab";
    repo = "rtabmap";
    tag = finalAttrs.version;
    hash = "sha256-6kDjIfUgyaqrsVAWO6k0h1qIDN/idMOJJxLpqMQ6DFY=";
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
    yaml-cpp
    libnabo
    libpointmatcher
    octomap
    freenect
    libdc1394
    librealsense
    libsForQt5.qtbase
    libGL
    libGLU
    vtkWithQt5
    zed-open-capture
    hidapi
  ];

  # Configure environment variables
  NIX_CFLAGS_COMPILE = "-Wno-c++20-extensions -I${vtkWithQt5}/include/vtk";

  cmakeFlags = [
    (lib.cmakeFeature "VTK_QT_VERSION" "5")
    (lib.cmakeFeature "VTK_DIR" "${vtkWithQt5}/lib/cmake/vtk-${lib.versions.majorMinor vtkWithQt5.version}")
    (lib.cmakeFeature "CMAKE_INCLUDE_PATH" "${vtkWithQt5}/include/vtk:${pcl}/include/pcl-${lib.versions.majorMinor pcl.version}")
  ];

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
  };
})
