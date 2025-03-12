{
  lib,
  stdenv,
  config,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  libsForQt5,
  pkg-config,

  # buildInputs
  eigen,
  libXt,
  libpcap,
  libusb1,

  # nativeBuildInputs
  boost186,
  flann,
  libpng,
  libtiff,
  qhull,
  vtk,

  gitUpdater,

  cudaSupport ? config.cudaSupport,
  cudaPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcl";
  version = "1.15.0-rc1";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    tag = "pcl-${finalAttrs.version}";
    hash = "sha256-T/zvev1x4w87j6Zn9dpqwIQfmfg2MsHt2Xto8Z1vhuQ=";
  };

  # remove attempt to prevent (x86/x87-specific) extended precision use
  # when SSE not detected
  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    sed -i '/-ffloat-store/d' cmake/pcl_find_sse.cmake
  '';

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    pkg-config
  ] ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    eigen
    libXt
    libpcap
    libsForQt5.qtbase
    libusb1
  ];

  propagatedBuildInputs = [
    boost186
    flann
    libpng
    libtiff
    qhull
    vtk
  ];

  cmakeFlags = lib.optionals cudaSupport [
    (lib.cmakeBool "WITH_CUDA" true)
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "pcl-"; };
  };

  meta = {
    homepage = "https://pointclouds.org/";
    description = "Open project for 2D/3D image and point cloud processing";
    changelog = "https://github.com/PointCloudLibrary/pcl/blob/pcl-${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = with lib.platforms; linux ++ darwin;
    badPlatforms = [
      # fatal error: 'omp.h' file not found
      lib.systems.inspect.patterns.isDarwin
    ];
  };
})
