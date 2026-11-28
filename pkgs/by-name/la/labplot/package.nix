{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  pkg-config,
  kdePackages,
  shared-mime-info,
  bison,
  flex,
  gsl,
  zlib,
  glibcLocales,
  writableTmpDirAsHomeHook,

  # Support for importing legacy Origin (.opj) project files
  withLiborigin ? true,
  liborigin,

  # Cantor backend integration for notebook-style computation
  withCantor ? true,
  # FFTW-based Fourier transform support
  withFftw ? true,
  fftw,

  # HDF5 file format import/export
  withHdf5 ? true,
  hdf5,

  # NetCDF file format import/export
  withNetcdf ? true,
  netcdf,

  # Live data support via MQTT
  withMqtt ? true,
  # Live data support via serial port devices
  withQtSerialPort ? true,
  # SVG import/rendering support
  withQtSvg ? true,

  # FITS (Flexible Image Transport System) astronomical data format support
  withFits ? true,
  cfitsio,

  # libcerf special functions (complex error function, etc.) for fitting
  withLibcerf ? true,
  libcerf,

  # MCAP file format support (robotics logging format)
  withMcap ? true,
  zstd,

  # Support for reading CERN ROOT (TH1 histogram) files, which are
  # compressed with zlib or lz4
  withRoot ? true,
  lz4,

  # ReadStat support for reading SPSS/SAS/Stata files; disabled by default on FreeBSD
  withReadstat ? !stdenv.hostPlatform.isFreeBSD,
  readstat,

  # Excel (.xlsx) file format support
  withXlsx ? true,

  # MAT file format (MATLAB) support
  withMatio ? true,
  matio,

  # Discount Markdown rendering support (e.g. for notes)
  withDiscount ? true,
  discount,

  # Orcus library support for importing ODS (OpenDocument Spreadsheet) files
  withOrcus ? true,
  liborcus,
  libixion,
  boost,

  # Eigen3 linear algebra library support
  withEigen ? true,
  eigen,

  # Vector BLF (Binary Logging Format) support for automotive CAN bus data
  withVectorBlf ? true,
  vector-blf,
  dbc-parser-cpp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "labplot";
  version = "2.12.1";

  src = fetchurl {
    url = "mirror://kde/stable/labplot/labplot-${finalAttrs.version}.tar.xz";
    hash = "sha256-4oFVv930DltvfEeRMTVW0eSBOARPIW8hDVFbn21sEGo=";
  };

  patches = [
    # backport build fix
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://invent.kde.org/education/labplot/-/commit/c2db2ec28aa8958f7041ae5cd03ddae9f44e5aa3.diff";
      hash = "sha256-0biKZXWMs5y1U9phAivEAbd2N4C/CiOKvk/QRAaPimo=";
    })

    # support liborcus-0.21
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://invent.kde.org/education/labplot/-/commit/ee17e7659a97b36b58cab28b2b56cede7cd153c6.patch";
      sha256 = "sha256-NC5CjO4X27NGlt17CwcPNsLx4ClbpE1zacH/XGaWwTs=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    shared-mime-info
    bison
    flex
    kdePackages.wrapQtAppsHook
  ];

  buildInputs =
    with kdePackages;
    [
      qtbase
      karchive
      kcompletion
      kconfig
      kcoreaddons
      kcrash
      ki18n
      kiconthemes
      kio
      ktextwidgets
      kxmlgui
      knewstuff
      kdoctools
      kparts
      kuserfeedback
      purpose
      syntax-highlighting
      poppler
    ]
    ++ [
      gsl
      zlib
    ]
    ++ lib.optionals withLiborigin [ liborigin ]
    ++ lib.optionals withCantor [ kdePackages.cantor ]
    ++ lib.optionals withFftw [ fftw ]
    ++ lib.optionals withHdf5 [ hdf5 ]
    ++ lib.optionals withNetcdf [ netcdf ]
    ++ lib.optionals withMqtt [ kdePackages.qtmqtt ]
    ++ lib.optionals withQtSerialPort [ kdePackages.qtserialport ]
    ++ lib.optionals withQtSvg [ kdePackages.qtsvg ]
    ++ lib.optionals withFits [ cfitsio ]
    ++ lib.optionals withLibcerf [ libcerf ]
    ++ lib.optionals withMcap [
      zstd
      lz4
    ]
    ++ lib.optionals withRoot [ lz4 ]
    ++ lib.optionals withReadstat [ readstat ]
    ++ lib.optionals withXlsx [ kdePackages.qxlsx ]
    ++ lib.optionals withMatio [ matio ]
    ++ lib.optionals withDiscount [ discount ]
    ++ lib.optionals withOrcus [
      liborcus
      libixion
      boost # needed for libixion headers
    ]
    ++ lib.optionals withEigen [ eigen ]
    ++ lib.optionals withVectorBlf [
      dbc-parser-cpp
      vector-blf
    ];

  cmakeFlags = [
    (lib.cmakeBool "QT_FIND_PRIVATE_MODULES" true)
    (lib.cmakeBool "ENABLE_REPRODUCIBLE" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_LIBORIGIN" withLiborigin)
    (lib.cmakeBool "ENABLE_CANTOR" withCantor)
    (lib.cmakeBool "ENABLE_FFTW" withFftw)
    (lib.cmakeBool "ENABLE_HDF5" withHdf5)
    (lib.cmakeBool "ENABLE_NETCDF" withNetcdf)
    (lib.cmakeBool "ENABLE_MQTT" withMqtt)
    (lib.cmakeBool "ENABLE_QTSERIALPORT" withQtSerialPort)
    (lib.cmakeBool "ENABLE_QTSVG" withQtSvg)
    (lib.cmakeBool "ENABLE_FITS" withFits)
    (lib.cmakeBool "ENABLE_LIBCERF" withLibcerf)
    (lib.cmakeBool "ENABLE_MCAP" withMcap)
    (lib.cmakeBool "ENABLE_ROOT" withRoot)
    (lib.cmakeBool "ENABLE_READSTAT" withReadstat)
    (lib.cmakeBool "ENABLE_XLSX" withXlsx)
    (lib.cmakeBool "ENABLE_MATIO" withMatio)
    (lib.cmakeBool "ENABLE_DISCOUNT" withDiscount)
    (lib.cmakeBool "ENABLE_ORCUS" withOrcus)
    (lib.cmakeBool "ENABLE_EIGEN3" withEigen)
    (lib.cmakeBool "ENABLE_VECTOR_BLF" withVectorBlf)
  ];

  nativeCheckInputs = [
    glibcLocales
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export QT_QPA_PLATFORM=offscreen
    export TZ=UTC
  '';

  doCheck = true;

  enableParallelBuilding = true;

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
    teams = with lib.teams; [ ngi ];
    platforms = lib.platforms.unix;
    mainProgram = "labplot";
  };
})
