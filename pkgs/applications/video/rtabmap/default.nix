{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, cmake
, opencv
, pcl
, libusb1
, eigen
, wrapQtAppsHook
, qtbase
, g2o
, ceres-solver
, libpointmatcher
, octomap
, freenect
, libdc1394
, librealsense
, libGL
, libGLU
, vtkWithQt5
, wrapGAppsHook3
, liblapack
, xorg
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

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook wrapGAppsHook3 ];
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
  ];

  # Disable warnings that are irrelevant to us as packagers
  cmakeFlags = [ "-Wno-dev" ];

  meta = with lib; {
    description = "Real-Time Appearance-Based 3D Mapping";
    homepage = "https://introlab.github.io/rtabmap/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ckie ];
    platforms = with platforms; linux;
  };
}
