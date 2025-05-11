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
  vtkWithQt5,
  zed-open-capture,
  hidapi,
  libpcap,
  qt5,
  # passthru
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rtabmap";
  version = "0.21.13";

  src = fetchFromGitHub {
    owner = "introlab";
    repo = "rtabmap";
    tag = "${finalAttrs.version}-noetic";
    hash = "sha256-W4yjHKb2BprPYkL8rLwLQcZDGgmMZ8279ntR+Eqj7R0=";
  };

  patches = [
    # https://github.com/introlab/rtabmap/pull/1496
    (fetchpatch {
      url = "https://github.com/phodina/rtabmap/commit/84c59a452b40a26edf1ba7ec8798700a2f9c3959.patch";
      hash = "sha256-kto02qcL2dW8Frt81GA+OCldPgCF5bAs/28w9amcf0o=";
    })
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    pkg-config
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
    libpcap
    qt5.full
    libusb1
    eigen
    g2o
    ceres-solver
    octomap
    freenect
    libdc1394
    libsForQt5.qtbase
    libGL
    libGLU
    vtkWithQt5
    zed-open-capture
    hidapi
  ];

  propagatedBuildInputs = [
    g2o
    libGLU
    ceres-solver
    octomap
    qt5.full
    vtkWithQt5
  ];

  postInstall = ''
    # Create a wrapper for RTABMap's CMake config
    mkdir -p $out/lib/cmake/rtabmap

    # Create a simple compatibility wrapper
    cat > $out/lib/cmake/rtabmap/RTABMapConfig.cmake << EOF
    # Ensure that VTK is properly loaded with targets
    find_package(VTK CONFIG REQUIRED COMPONENTS GUISupportQt
                             PATHS "${vtkWithQt5}/lib/cmake/vtk" NO_DEFAULT_PATH)

    # Include the original RTABMap config
    include("$out/lib/rtabmap-0.21/RTABMapConfig.cmake")
    EOF

    # Add an environment setup script for dependent packages
    mkdir -p $out/nix-support
    cat > $out/nix-support/setup-hook << EOF
    # Add our directories to CMake paths
    cmakeFlagsHook() {
      cmakeFlags="\$cmakeFlags -DVTK_DIR=${vtkWithQt5}/lib/cmake/vtk -DQt5_DIR=${qt5.qtbase.dev}/lib/cmake/Qt5 -DRTABMAP_DIR=$out/lib/cmake/rtabmap"
    }

    # Standard environment variables
    export CMAKE_PREFIX_PATH="\''${CMAKE_PREFIX_PATH:+\''$CMAKE_PREFIX_PATH:}${qt5.qtbase.dev}/lib/cmake:${vtkWithQt5}/lib/cmake:$out/lib/cmake"
    export Qt5_DIR="${qt5.qtbase.dev}/lib/cmake/Qt5"
    export VTK_DIR="${vtkWithQt5}/lib/cmake/vtk"
    EOF
  '';

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
