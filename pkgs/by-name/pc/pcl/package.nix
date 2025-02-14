{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qhull,
  flann,
  boost,
  vtk,
  eigen,
  pkg-config,
  libsForQt5,
  libusb1,
  libpcap,
  libtiff,
  libXt,
  libpng,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}:

stdenv.mkDerivation rec {
  pname = "pcl";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "PointCloudLibrary";
    repo = "pcl";
    rev = "${pname}-${version}";
    sha256 = "sha256-JDiDAmdpwUR3Sff63ehyvetIFXAgGOrI+HEaZ5lURps=";
  };

  # remove attempt to prevent (x86/x87-specific) extended precision use
  # when SSE not detected
  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    sed -i '/-ffloat-store/d' cmake/pcl_find_sse.cmake
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    libsForQt5.wrapQtAppsHook
  ] ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    eigen
    libusb1
    libpcap
    libsForQt5.qtbase
    libXt
  ];

  propagatedBuildInputs = [
    boost
    flann
    libpng
    libtiff
    qhull
    vtk
  ];

  cmakeFlags = lib.optionals cudaSupport [ "-DWITH_CUDA=true" ];

  meta = {
    homepage = "https://pointclouds.org/";
    description = "Open project for 2D/3D image and point cloud processing";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
