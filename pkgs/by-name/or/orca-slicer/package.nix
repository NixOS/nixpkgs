{
  stdenv,
  lib,
  binutils,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  boost,
  cereal,
  cgal,
  curl,
  dbus,
  eigen,
  expat,
  ffmpeg,
  gcc-unwrapped,
  glew,
  glfw,
  glib,
  glib-networking,
  gmp,
  gst_all_1,
  gtest,
  gtk3,
  hicolor-icon-theme,
  ilmbase,
  libpng,
  mesa,
  mpfr,
  nlopt,
  opencascade-occt_7_6,
  openvdb,
  opencv,
  pcre,
  systemd,
  tbb_2021_11,
  webkitgtk_4_0,
  wxGTK31,
  xorg,
  withSystemd ? stdenv.hostPlatform.isLinux,
}:
let
  wxGTK' =
    (wxGTK31.override {
      withCurl = true;
      withPrivateFonts = true;
      withWebKit = true;
    }).overrideAttrs
      (old: {
        configureFlags = old.configureFlags ++ [
          # Disable noisy debug dialogs
          "--enable-debug=no"
        ];
      });
in
stdenv.mkDerivation rec {
  pname = "orca-slicer";
  version = "v2.2.0-unstable-2025-01-06";

  src = fetchFromGitHub {
    owner = "SoftFever";
    repo = "OrcaSlicer";
    rev = "99a0facfb3a5c9b4e661e536825c08393053cb53";
    hash = "sha256-XWM04Vx65q+Vc+s3YLucS63IhGVw8ODhL2m+47nZKs8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    wxGTK'
  ];

  buildInputs =
    [
      binutils
      (boost.override {
        enableShared = true;
        enableStatic = false;
        extraFeatures = [
          "log"
          "thread"
          "filesystem"
        ];
      })
      boost.dev
      cereal
      cgal
      curl
      dbus
      eigen
      expat
      ffmpeg
      gcc-unwrapped
      glew
      glfw
      glib
      glib-networking
      gmp
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-good
      gtk3
      hicolor-icon-theme
      ilmbase
      libpng
      mesa
      mesa.osmesa
      mesa.drivers
      mpfr
      nlopt
      opencascade-occt_7_6
      openvdb
      pcre
      tbb_2021_11
      webkitgtk_4_0
      wxGTK'
      xorg.libX11
      opencv
    ]
    ++ lib.optionals withSystemd [ systemd ]
    ++ checkInputs;

  patches = [
    # Fix for webkitgtk linking
    ./patches/0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch
    ./patches/dont-link-opencv-world-orca.patch
    ./patches/fix-boost.patch
  ];

  doCheck = true;
  checkInputs = [ gtest ];

  separateDebugInfo = true;

  NLOPT = nlopt;

  NIX_CFLAGS_COMPILE = toString [
    "-Wno-ignored-attributes"
    "-I${opencv.out}/include/opencv4"
    "-Wno-error=template-id-cdtor"
    "-Wno-error=incompatible-pointer-types"
    "-Wno-template-id-cdtor"
    "-Wno-uninitialized"
    "-Wno-unused-result"
    "-Wno-deprecated-declarations"
    "-Wno-use-after-free"
    "-Wno-format-overflow"
    "-Wno-stringop-overflow"
    "-DBOOST_ALLOW_DEPRECATED_HEADERS"
    "-DBOOST_MATH_DISABLE_STD_FPCLASSIFY"
    "-DBOOST_MATH_NO_LONG_DOUBLE_MATH_FUNCTIONS"
    "-DBOOST_MATH_DISABLE_FLOAT128"
    "-DBOOST_MATH_NO_QUAD_SUPPORT"
    "-DBOOST_MATH_MAX_FLOAT128_DIGITS=0"
    "-DBOOST_CSTDFLOAT_NO_LIBQUADMATH_SUPPORT"
    "-DBOOST_MATH_DISABLE_FLOAT128_BUILTIN_FPCLASSIFY"
  ];

  NIX_LDFLAGS = toString [
    (lib.optionalString withSystemd "-ludev")
    "-L${mesa.osmesa}/lib"
    "-L${mesa.drivers}/lib"
    "-L${boost}/lib"
    "-lboost_log"
    "-lboost_log_setup"
  ];

  prePatch = ''
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake
  '';

  cmakeFlags = [
    "-DSLIC3R_STATIC=0"
    "-DSLIC3R_FHS=1"
    "-DSLIC3R_GTK=3"
    "-DBBL_RELEASE_TO_PUBLIC=1"
    "-DBBL_INTERNAL_TESTING=0"
    "-DDEP_WX_GTK3=ON"
    "-DSLIC3R_BUILD_TESTS=0"
    "-DCMAKE_CXX_FLAGS=-DBOOST_LOG_DYN_LINK"
    "-DBOOST_LOG_DYN_LINK=1"
    "-DBOOST_ALL_DYN_LINK=1"
    "-DBOOST_LOG_NO_LIB=OFF"
    "-DCMAKE_CXX_FLAGS=-DGL_SILENCE_DEPRECATION"
    "-DCMAKE_EXE_LINKER_FLAGS=-Wl,--no-as-needed"
    "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,${mesa.drivers}/lib -Wl,-rpath,${mesa.osmesa}/lib"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib:${
        lib.makeLibraryPath [
          mesa.drivers
          mesa.osmesa
          glew
        ]
      }"
      --prefix LIBGL_DRIVERS_PATH : "${mesa.drivers}/lib/dri"
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    )
  '';

  meta = {
    description = "G-code generator for 3D printers (Bambu, Prusa, Voron, VzBot, RatRig, Creality, etc.)";
    homepage = "https://github.com/SoftFever/OrcaSlicer";
    changelog = "https://github.com/SoftFever/OrcaSlicer/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      zhaofengli
      ovlach
      pinpox
      liberodark
    ];
    mainProgram = "orca-slicer";
    platforms = lib.platforms.linux;
  };
}
