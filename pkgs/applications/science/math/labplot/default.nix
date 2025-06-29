{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  cmake,
  shared-mime-info,
  qt6,
  kdePackages,
  gsl,
  bison,
  pkg-config,
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

stdenv.mkDerivation rec {
  pname = "labplot";
  version = "2.11.1";

  src = fetchurl {
    url = "mirror://kde/stable/labplot/labplot-${version}.tar.xz";
    sha256 = "sha256-U6pqyN85Mk2ZRj5g2I3iU0azko2luw8hCwVjSJBGZ50=";
  };

  cmakeFlags = [
    # Disable Vector BLF since it depends on DBC parser which fails to be detected
    "-DENABLE_VECTOR_BLF=OFF"
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    shared-mime-info
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg

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
    gsl

    kdePackages.poppler
    bison
    pkg-config
    fftw
    hdf5
    netcdf
    cfitsio
    libcerf
    # kdePackages.cantor
    zlib
    lz4
    readstat
    matio
    qt6.qtserialport
    discount
  ];

  meta = with lib; {
    description = "LabPlot is a FREE, open source and cross-platform Data Visualization and Analysis software accessible to everyone";
    homepage = "https://labplot.kde.org";
    license = with licenses; [
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
    maintainers = with maintainers; [ hqurve ];
    mainProgram = "labplot2";
    platforms = platforms.unix;
  };
}
