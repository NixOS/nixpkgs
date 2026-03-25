{
  lib,
  stdenv,
  fetchpatch2,
  fetchurl,
  cmake,
  extra-cmake-modules,
  shared-mime-info,
  kdePackages,
  bison,
  gsl,
  poppler,
  fftw,
  hdf5,
  netcdf,
  cfitsio,
  libcerf,
  zlib,
  lz4,
  readstat,
  matio,
  discount,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labplot";
  version = "2.12.1";

  src = fetchurl {
    url = "mirror://kde/stable/labplot/labplot-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-4oFVv930DltvfEeRMTVW0eSBOARPIW8hDVFbn21sEGo=";
  };

  cmakeFlags = [
    # Disable Vector BLF since it depends on DBC parser which fails to be detected
    "-DENABLE_VECTOR_BLF=OFF"
  ];

  patches = [
    # fix building with Qt 6.10
    (fetchpatch2 {
      url = "https://github.com/KDE/labplot/commit/b0e233b6b20134177af40e8904b593b8dbc18ada.patch?full_index=1";
      hash = "sha256-alishF4pq8VVIlyysKF8pAyy7+u82rRO1GLFrdd3a5g=";
    })
    # fix missing include for QElapsedTimer
    (fetchpatch2 {
      url = "https://github.com/KDE/labplot/commit/c2db2ec28aa8958f7041ae5cd03ddae9f44e5aa3.patch?full_index=1";
      hash = "sha256-g7hWVJWBK1wDGJy9xjAP45wjVI/f0tBkexW29ux6R+M=";
    })
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    shared-mime-info
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.karchive
    kdePackages.kcompletion
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.kcrash
    kdePackages.kdoctools
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kio
    kdePackages.knewstuff
    kdePackages.kparts
    kdePackages.ktextwidgets
    kdePackages.kxmlgui
    kdePackages.syntax-highlighting
    bison
    gsl
    poppler
    fftw
    hdf5
    netcdf
    cfitsio
    libcerf
    zlib
    lz4
    readstat
    matio
    kdePackages.qtserialport
    discount
  ];

  meta = {
    description = "Free, open source and cross-platform data visualization and analysis software accessible to everyone";
    homepage = "https://labplot.kde.org";
    license = with lib.licenses; [
      asl20
      bsd3
      cc-by-30
      cc0
      gpl2Only
      gpl2Plus
      gpl3Only
      gpl3Plus
      lgpl3Plus
      mit
    ];
    maintainers = with lib.maintainers; [ hqurve ];
    mainProgram = "labplot2";
    platforms = lib.platforms.unix;
  };
})
