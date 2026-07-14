{
  clangStdenv,
  lib,
  binutils,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  boost186,
  cereal,
  cgal_5,
  curl,
  dbus,
  draco,
  eigen_5,
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
  libsecret,
  libpng,
  mpfr,
  nlopt,
  opencascade-occt_7_6,
  openvdb,
  opencv,
  systemd,
  onetbb,
  webkitgtk_4_1,
  wxwidgets_3_3,
  libx11,
  libnoise,
  withSystemd ? clangStdenv.hostPlatform.isLinux,
  withNvidiaGLWorkaround ? false,
}:
let
  wxGTK' =
    (wxwidgets_3_3.override {
      withPrivateFonts = true;
      withWebKit = true;
      withEGL = true;
    }).overrideAttrs
      (old: {
        buildInputs = old.buildInputs ++ [ libsecret ];
        configureFlags = old.configureFlags ++ [
          # Disable noisy debug dialogs
          "--enable-debug=no"
          "--enable-secretstore"
        ];
      });
in
# Build with clang even on Linux, because GCC uses absolutely obscene amounts of memory
# on this particular code base (OOM with 32GB memory and --cores 16 on GCC, succeeds
# with --cores 32 on clang).
clangStdenv.mkDerivation (finalAttrs: {
  pname = "orca-slicer";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "OrcaSlicer";
    repo = "OrcaSlicer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gUwLC0XkeohEdL0EScdOrA8MWXGuR8kUfezoQsk9i/A=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    wxGTK'
  ];

  buildInputs = [
    binutils
    (boost186.override {
      enableShared = true;
      enableStatic = false;
      extraFeatures = [
        "log"
        "thread"
        "filesystem"
      ];
    })
    boost186.dev
    cereal
    cgal_5
    curl
    dbus
    draco
    eigen_5
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
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gtk3
    hicolor-icon-theme
    libsecret
    libpng
    mpfr
    nlopt
    opencascade-occt_7_6
    openvdb
    onetbb
    webkitgtk_4_1
    wxGTK'
    libx11
    opencv.cxxdev
    libnoise
  ]
  ++ lib.optionals withSystemd [ systemd ]
  ++ finalAttrs.checkInputs;

  patches = [
    # Fix for webkitgtk linking
    ./patches/0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch
    # Link opencv_core and opencv_imgproc instead of opencv_world
    ./patches/dont-link-opencv-world-orca.patch
    # The changeset from https://github.com/OrcaSlicer/OrcaSlicer/pull/7650, can be removed when that PR gets merged
    # Allows disabling the update nag screen
    (fetchpatch {
      name = "pr-7650-configurable-update-check.patch";
      url = "https://github.com/OrcaSlicer/OrcaSlicer/commit/300df7c99b0a2173f645c8bf40e8758eb5f2c486.patch";
      hash = "sha256-hgQeagPhS3aNQoFSq0S+Ch60ygm81uHMIvGopw/AZT8=";
    })

    # Pick https://github.com/prusa3d/PrusaSlicer/pull/14207 to remove unused and insecure ilmbase dependency
    ./patches/no-ilmbase.patch
  ];

  doCheck = true;
  checkInputs = [ gtest ];

  separateDebugInfo = true;

  env = {
    NLOPT = nlopt;

    NIX_CFLAGS_COMPILE = toString [
      "-Wno-ignored-attributes"
      "-I${opencv.out}/include/opencv4"
      "-Wno-error=incompatible-pointer-types"
      "-Wno-error=format-security"
      "-Wno-uninitialized"
      "-Wno-unused-result"
      "-Wno-deprecated-declarations"
      "-Wno-format-overflow"
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
      "-L${boost186}/lib"
      "-lboost_log"
      "-lboost_log_setup"
    ];
  };

  prePatch = ''
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake
    sed -i 's|"libnoise/noise.h"|"noise/noise.h"|' src/libslic3r/PerimeterGenerator.cpp
    sed -i 's|"libnoise/noise.h"|"noise/noise.h"|' src/libslic3r/Feature/FuzzySkin/FuzzySkin.cpp
  '';

  cmakeFlags = [
    (lib.cmakeBool "SLIC3R_STATIC" false)
    (lib.cmakeBool "SLIC3R_FHS" true)
    (lib.cmakeFeature "SLIC3R_GTK" "3")
    (lib.cmakeBool "BBL_RELEASE_TO_PUBLIC" true)
    (lib.cmakeBool "BBL_INTERNAL_TESTING" false)
    (lib.cmakeBool "SLIC3R_BUILD_TESTS" false)
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DGL_SILENCE_DEPRECATION")
    (lib.cmakeFeature "CMAKE_EXE_LINKER_FLAGS" "-Wl,--no-as-needed")
    (lib.cmakeBool "ORCA_VERSION_CHECK_DEFAULT" false)
    (lib.cmakeFeature "LIBNOISE_INCLUDE_DIR" "${libnoise}/include")
    (lib.cmakeFeature "LIBNOISE_LIBRARY_RELEASE" "${libnoise}/lib/libnoise-static.a")
    "-Wno-dev"
  ];

  # Generate translation files
  postBuild = "( cd .. && ./scripts/run_gettext.sh )";

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib:${
        lib.makeLibraryPath [
          glew
        ]
      }"
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
      ${lib.optionalString withNvidiaGLWorkaround ''
        --set __GLX_VENDOR_LIBRARY_NAME mesa
        --set __EGL_VENDOR_LIBRARY_FILENAMES /run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json
        --set MESA_LOADER_DRIVER_OVERRIDE zink
        --set GALLIUM_DRIVER zink
        --set WEBKIT_DISABLE_DMABUF_RENDERER 1
      ''}
    )
  '';

  postInstall = ''
    rm $out/LICENSE.txt
  '';

  meta = {
    description = "G-code generator for 3D printers (Bambu, Prusa, Voron, VzBot, RatRig, Creality, etc.)";
    homepage = "https://github.com/OrcaSlicer/OrcaSlicer";
    changelog = "https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      zhaofengli
      ovlach
      pinpox
      liberodark
      zraexy
    ];
    mainProgram = "orca-slicer";
    platforms = lib.platforms.linux;
  };
})
