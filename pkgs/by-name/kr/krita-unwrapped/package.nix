{
  stdenv,
  SDL2,
  boost,
  cmake,
  curl,
  eigen_5,
  exiv2,
  fetchurl,
  fetchpatch,
  fftw,
  fribidi,
  giflib,
  gsl,
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

  version = "6.0.4.1";
  src = fetchurl {
    url = "mirror://kde/stable/krita/${finalAttrs.version}/krita-${finalAttrs.version}.tar.gz";
    hash = "sha256-6v8AUhlYUDqh0+8SBtdeALV+1lmT6VNonwoEhQQn4tg=";
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

  patches = [
    (fetchpatch {
      # Update SIP ABI to 13.8
      url = "https://invent.kde.org/graphics/krita/-/commit/30182dbfe789c9b44e5762978bf9ebb22c4f72b6.patch";
      hash = "sha256-IZNaRmDYnj7M+7gg3fqHrhI+t5fgE6/ecxWW6slvX4g=";
    })
    (fetchpatch {
      # qt 6.12 support
      # Fix invalid widget class name
      url = "https://invent.kde.org/graphics/krita/-/commit/3f5b2882017f4e12c9b021de0ea24e6dd2eb26dd.patch";
      hash = "sha256-Oq/ojwTYt2bmXQm0UuIVCIN+7PVgTO1WGbcFUnDDFIA=";
    })
  ];

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
