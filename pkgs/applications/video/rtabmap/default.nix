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
, wrapGAppsHook
, liblapack
, xorg
}:

stdenv.mkDerivation rec {
  pname = "rtabmap";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "introlab";
    repo = "rtabmap";
    rev = "refs/tags/${version}";
    hash = "sha256-1xb8O3VrErldid2OgAUMG28mSUO7QBUsPuSz8p03tSI";
  };

  patches = [
    # Fix build with g2o 20230806
    (fetchpatch {
      url = "https://github.com/introlab/rtabmap/commit/85cc6fe3c742855ad16c8442895e12dbb10b6e8b.patch";
      hash = "sha256-P6GkYKCNwe9dgZdgF/oEhgjA3bJnwXFWJCPoyIknQCo=";
    })
    # Fix typo in previous patch
    (fetchpatch {
      url = "https://github.com/introlab/rtabmap/commit/c4e94bcdc31b859c1049724dbb7671e4597d86de.patch";
      hash = "sha256-1btkV4/y+bnF3xEVqlUy/9F6BoANeTOEJjZLmRzG3iA=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook wrapGAppsHook ];
  buildInputs = [
    ## Required
    opencv
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
