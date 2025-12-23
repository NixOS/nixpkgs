{
  lib,
  stdenv,
  config,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  qt6,
  pkg-config,

  # buildInputs
  eigen,
  libXt,
  libpcap,
  libusb1,
  llvmPackages,
  nanoflann,

  # nativeBuildInputs
  boost,
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
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    tag = "pcl-${finalAttrs.version}";
    hash = "sha256-+KyaajJM0I5CAcr8AiOLC4TkGV3Gm73a0/X8LQWFZMI=";
  };

  strictDeps = true;

  # remove attempt to prevent (x86/x87-specific) extended precision use
  # when SSE not detected
  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    sed -i '/-ffloat-store/d' cmake/pcl_find_sse.cmake
  '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    eigen
    libXt
    libpcap
    qt6.qtbase
    libusb1
    nanoflann
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  propagatedBuildInputs = [
    boost
    flann
    libpng
    libtiff
    qhull
    vtk
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_CUDA" cudaSupport)
    (lib.cmakeBool "BUILD_GPU" cudaSupport)
    (lib.cmakeBool "PCL_ENABLE_MARCHNATIVE" false)
    (lib.cmakeBool "WITH_CUDA" cudaSupport)
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "pcl-";
    ignoredVersions = "rc";
  };

  meta = {
    homepage = "https://pointclouds.org/";
    description = "Open project for 2D/3D image and point cloud processing";
    changelog = "https://github.com/PointCloudLibrary/pcl/blob/pcl-${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      GaetanLepage
      usertam
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
