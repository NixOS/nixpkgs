{
  stdenv,
  SDL2,
  boost,
  cmake,
  curl,
  eigen_5,
  exiv2,
  fetchurl,
  fftw,
  fribidi,
  giflib,
  gsl,
  ilmbase,
  immer,
  kseexpr,
  lager,
  lcms2,
  lib,
  libaom,
  libheif,
  libjxl,
  libmypaint,
  libraw,
  qt6,
  kdePackages,
  libunibreak,
  libwebp,
  opencolorio,
  openexr,
  openjpeg,
  pkg-config,
  python3Packages,
  xsimd,
  zug,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krita-unwrapped";

  version = "6.0.0";
  src = fetchurl {
    url = "mirror://kde/stable/krita/${finalAttrs.version}/krita-${finalAttrs.version}.tar.gz";
    hash = "sha256-kytodhJvfGKeQn7j0BIwDIKGsFoYQnc1S0FK9kGg8e0=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    python3Packages.sip
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    libraw
    fftw
    eigen_5
    exiv2
    fribidi
    lcms2
    gsl
    openexr
    lager
    libaom
    libheif

    giflib
    libjxl
    openjpeg
    opencolorio
    xsimd
    curl
    ilmbase
    immer
    kseexpr
    libmypaint
    libunibreak
    libwebp
    SDL2
    zug
    python3Packages.pyqt6

    qt6.qtmultimedia
    qt6.qttools
  ]
  ++ (with kdePackages; [
    breeze-icons
    karchive
    kcompletion
    kconfig
    kcoreaddons
    kcrash
    kguiaddons
    ki18n
    kio
    kitemmodels
    kitemviews
    kwidgetsaddons
    kwindowsystem
    mlt
    poppler
    quazip
    libkdcraw
  ]);

  # Krita runs custom python scripts in CMake with custom PYTHONPATH which krita determined in their CMake script.
  # Patch the PYTHONPATH so python scripts can import sip successfully.
  postPatch =
    let
      pythonPath = python3Packages.makePythonPath (
        with python3Packages;
        [
          sip
          setuptools
        ]
      );
    in
    ''
      substituteInPlace cmake/modules/FindSIP.cmake \
        --replace 'PYTHONPATH=''${_sip_python_path}' 'PYTHONPATH=${pythonPath}'
      substituteInPlace cmake/modules/SIPMacros.cmake \
        --replace 'PYTHONPATH=''${_krita_python_path}' 'PYTHONPATH=${pythonPath}'

      substituteInPlace plugins/impex/jp2/jp2_converter.cc \
        --replace '<openjpeg.h>' '<${openjpeg.incDir}/openjpeg.h>'
    '';

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [
    "-DBUILD_WITH_QT6=ON"
    "-DALLOW_UNSTABLE=QT6"
    "-DENABLE_UPDATERS=OFF"
    "-DBUILD_KRITA_QT_DESIGNER_PLUGINS=ON"
  ];

  meta = {
    description = "Free and open source painting application";
    homepage = "https://krita.org/";
    maintainers = with lib.maintainers; [
      sifmelcara
    ];
    mainProgram = "krita";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
  };
})
