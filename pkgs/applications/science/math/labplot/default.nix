{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  pkg-config,
  extra-cmake-modules,
  shared-mime-info,
  bison,
  flex,
  wrapQtAppsHook,

  qtbase,

  karchive,
  kcompletion,
  kconfig,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kiconthemes,
  kio,
  knewstuff,
  kparts,
  ktextwidgets,
  kxmlgui,
  syntax-highlighting,

  gsl,

  poppler,
  fftw,
  hdf5,
  netcdf,
  cfitsio,
  libcerf,
  cantor,
  zlib,
  lz4,
  readstat,
  matio,
  qtserialport,
  discount,
}:

stdenv.mkDerivation rec {
  pname = "labplot";
  version = "2.12.1";

  src = fetchurl {
    url = "mirror://kde/stable/labplot/labplot-${version}.tar.xz";
    hash = "sha256-4oFVv930DltvfEeRMTVW0eSBOARPIW8hDVFbn21sEGo=";
  };

  patches = [
    # backport build fix
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://invent.kde.org/education/labplot/-/commit/c2db2ec28aa8958f7041ae5cd03ddae9f44e5aa3.diff";
      hash = "sha256-0biKZXWMs5y1U9phAivEAbd2N4C/CiOKvk/QRAaPimo=";
    })
  ];

  cmakeFlags = [
    "-DQT_FIND_PRIVATE_MODULES=ON"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
    shared-mime-info
    bison
    flex
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase

    karchive
    kcompletion
    kconfig
    kcoreaddons
    kcrash
    kdoctools
    ki18n
    kiconthemes
    kio
    knewstuff
    kparts
    ktextwidgets
    kxmlgui

    syntax-highlighting
    gsl

    poppler
    fftw
    hdf5
    netcdf
    cfitsio
    libcerf
    cantor
    zlib
    lz4
    readstat
    matio
    qtserialport
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
    maintainers = [ ];
    mainProgram = "labplot2";
    platforms = lib.platforms.unix;
  };
}
