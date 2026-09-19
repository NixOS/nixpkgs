{
  pkgs,
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  boost,
  eigen,
  embree,
  libGL,
  libpng,
  libtiff,
  lz4,
  opencolorio,
  openexr,
  openshadinglanguage,
  python3,
  qt5,
  xercesc,
  enablePython ? false,
  enableQt5 ? true,
  sse42Support ? stdenv.hostPlatform.sse4_2Support,
  avxSupport ? stdenv.hostPlatform.avxSupport,
  avx2Support ? stdenv.hostPlatform.avx2Support,
}:
let
  boost_python = boost.override {
    enablePython = enablePython;
    python = python3;
  };
  happly_src = fetchFromGitHub {
    owner = "MarcusTU";
    repo = "happly";
    rev = "1e74cc732e039df91d617072a8b4503806907673";
    hash = "sha256-05rqtyATIn/iDYMp5eb0Osc3quxNYcOLKW26aYgYGbs=";
  };
  # does not compile with openimageio v3 yet
  openimageio2 = callPackage ./openimageio { };
  openshadinglanguage_openimageio2 = openshadinglanguage.override {
    openimageio = openimageio2;
  };
  embree_openimageio2 = embree.override {
    openimageio = openimageio2;
  };
  buildStudio = enablePython && enableQt5;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "appleseed";
  version = "2.1.0-beta-unstable-2026-05-03";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "appleseedhq";
    repo = "appleseed";
    rev = "01206dc8fa1c3a0e1a7e5acbced874c9a71b40f0";
    hash = "sha256-cyoUT2ig9BhGnN3N2Oq58PlRBh9P/tYQHh/oE6a1tws=";
  };

  patches = [
    ./fix-cmake4.patch
    ./fix-cmake-cmp0043.patch
    ./fix-cmake-xercesc.patch
    ./bcd-use-system-eigen.patch
    ./find-openimageio-tools.patch
    ./fix-python313.patch
  ];

  postPatch = ''
    # boost 1.89
    substituteInPlace CMakeLists.txt --replace-fail \
      "find_package (Boost 1.86.00 REQUIRED COMPONENTS atomic chrono date_time filesystem regex system thread wave)" \
      "find_package (Boost 1.86.00 REQUIRED COMPONENTS atomic chrono date_time filesystem regex thread wave)"
    # remove vendored eigen
    rm -rv src/thirdparty/bcd/ext/eigen
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    openshadinglanguage_openimageio2
  ]
  ++ lib.optionals enablePython [
    python3
    python3.pkgs.wrapPython
  ]
  ++ lib.optionals enableQt5 [
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    boost_python
    eigen
    embree_openimageio2
    libGL
    libpng
    libtiff
    lz4
    opencolorio
    openimageio2
    openexr
    openshadinglanguage_openimageio2
    xercesc
  ]
  ++ lib.optionals enablePython [
    python3
  ]
  ++ lib.optionals enableQt5 [
    qt5.qtbase
  ];

  cmakeFlags = [
    (lib.cmakeBool "WARNINGS_AS_ERRORS" false)
    (lib.cmakeBool "USE_STATIC_BOOST" false)
    (lib.cmakeBool "WITH_STUDIO" buildStudio)
    (lib.cmakeBool "WITH_BENCH" false) # file INSTALL can not find appleseed.bench.xml
    (lib.cmakeBool "WITH_PYTHON2_BINDINGS" false)
    (lib.cmakeBool "WITH_PYTHON3_BINDINGS" enablePython)
    (lib.cmakeBool "WITH_EMBREE" true)
    (lib.cmakeBool "USE_SSE" true)
    (lib.cmakeBool "USE_SSE42" sse42Support)
    (lib.cmakeBool "USE_AVX" avxSupport)
    (lib.cmakeBool "USE_AVX2" avx2Support)
    (lib.cmakeFeature "happly_ROOT" "${happly_src}")
  ];

  dontWrapQtApps = true;
  preFixup = lib.optionalString buildStudio ''
    wrapQtApp "$out/bin/appleseed.studio" --set PYTHONHOME "${python3}"
  '';

  meta = {
    description = "Open source, physically-based global illumination rendering engine";
    homepage = "https://appleseedhq.net";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      wishstudio
    ];
    platforms = lib.platforms.all;
  };
})
