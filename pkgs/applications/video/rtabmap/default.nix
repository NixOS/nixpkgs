{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, opencv, pcl, libusb1, eigen
, wrapQtAppsHook, qtbase, g2o, ceres-solver, libpointmatcher, octomap, freenect
, libdc1394, librealsense, libGL, libGLU, vtk_8_withQt5, wrapGAppsHook, liblapack
, xorg }:

stdenv.mkDerivation rec {
  pname = "rtabmap";
  version = "unstable-2022-09-24";

  src = fetchFromGitHub {
    owner = "introlab";
    repo = "rtabmap";
    rev = "fa31affea0f0bd54edf1097b8289209c7ac0548e";
    sha256 = "sha256-kcY+o31fSmwxBcvF/e+Wu6OIqiQzLKgEJJxcj+g3qDM=";
  };

  patches = [
    # Our Qt5 seems to be missing PrintSupport.. I think?
    ./0001-remove-printer-support.patch
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
    vtk_8_withQt5
  ];

  # Disable warnings that are irrelevant to us as packagers
  cmakeFlags = [ "-Wno-dev" ];

  # We run one of the executables we build while the build is
  # still running (and patchelf hasn't been invoked) which means
  # the RPATH is not set correctly. This hacks around that error:
  #
  # build/bin/rtabmap-res_tool: error while loading shared libraries: librtabmap_utilite.so.0.20: cannot open shared object file: No such file or directory
  LD_LIBRARY_PATH = "/build/source/build/bin";

  meta = with lib; {
    description = "Real-Time Appearance-Based 3D Mapping";
    homepage = "https://introlab.github.io/rtabmap/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ckie ];
    platforms = with platforms; linux;
  };
}
