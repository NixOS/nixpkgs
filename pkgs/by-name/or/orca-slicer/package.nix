{
  clangStdenv,
  lib,
  binutils,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  assimp,
  boost186,
  cereal,
  cgal,
  curl,
  dbus,
  draco,
  eigen_5,
  expat,
  ffmpeg,
  glfw,
  glib,
  glib-networking,
  gmp,
  gst_all_1,
  gtest,
  gtk3,
  hicolor-icon-theme,
  libdatachannel,
  libjpeg,
  libsecret,
  libpng,
  mpfr,
  nlopt,
  opencascade-occt_8,
  openssl,
  openvdb,
  opencv,
  python312,
  systemdLibs,
  onetbb,
  uv,
  webkitgtk_4_1,
  wxwidgets_3_3,
  wxinspector,
  libx11,
  libnoise,
  zlib,
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

  # The plugin system embeds CPython 3.12 (the version is hardcoded in
  # src/slic3r/plugin/PythonInterpreter.cpp).
  python = python312;
in
# Build with clang even on Linux, because GCC uses absolutely obscene amounts of memory
# on this particular code base (OOM with 32GB memory and --cores 16 on GCC, succeeds
# with --cores 32 on clang).
clangStdenv.mkDerivation (finalAttrs: {
  pname = "orca-slicer";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "OrcaSlicer";
    repo = "OrcaSlicer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WL3tXUkj/XIltcUSSnHGbOXWWLuYZ/hEeZ6L94w72c0=";
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
    assimp
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
    cgal
    curl
    dbus
    draco
    eigen_5
    expat
    ffmpeg
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
    libdatachannel
    libjpeg
    libsecret
    libpng
    mpfr
    nlopt
    opencascade-occt_8
    openssl
    openvdb
    onetbb
    python
    finalAttrs.passthru.slvs
    webkitgtk_4_1
    wxGTK'
    # Must be built against the same wxWidgets as orca-slicer itself
    (wxinspector.override { wxwidgets_3_3 = wxGTK'; })
    libx11
    opencv.cxxdev
    libnoise
    zlib
  ]
  ++ lib.optionals withSystemd [ systemdLibs ]
  ++ finalAttrs.checkInputs;

  patches = [
    # Link opencv_core and opencv_imgproc instead of opencv_world
    ./patches/dont-link-opencv-world-orca.patch
    # https://github.com/OrcaSlicer/OrcaSlicer/pull/7650 (rebased), can be removed when that
    # PR gets merged. Allows disabling the update nag screen.
    ./patches/configurable-update-check.patch

    # Pick https://github.com/prusa3d/PrusaSlicer/pull/14207 to remove unused and insecure ilmbase dependency
    ./patches/no-ilmbase.patch

    # Fix build with wxWidgets 3.3.4
    # https://github.com/OrcaSlicer/OrcaSlicer/pull/16370
    (fetchpatch {
      name = "wxwidgets-3.3.4-DismissEditor.patch";
      url = "https://github.com/OrcaSlicer/OrcaSlicer/commit/2c9734381174a34b15850576ad6bc627dc1e7ce7.patch";
      hash = "sha256-Hbc5RxVV3oCqr4e8WGmVgnM7SnDZR/6ajj3SU/srjog=";
    })
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

  postPatch = ''
    # nixpkgs' libnoise installs its headers under include/noise
    substituteInPlace src/libslic3r/Feature/FuzzySkin/FuzzySkin.cpp \
      --replace-fail '<libnoise/module/modulebase.h>' '<noise/module/modulebase.h>' \
      --replace-fail '"libnoise/noise.h"' '"noise/noise.h"'

    # Upstream expects the Python 3.12.13 runtime and FFmpeg libraries from its own deps
    # prefix, and copies/installs them next to the binary; use nixpkgs' Python and FFmpeg
    # instead. The Python root is also baked into the binary as the plugin runtime.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(_bundled_python_version "3.12.13")' 'set(_bundled_python_version "${python.version}")' \
      --replace-fail 'set(_bundled_python_root "''${CMAKE_PREFIX_PATH}/libpython")' 'set(_bundled_python_root "${python}")' \
      --replace-fail 'install(FILES ''${LIBRARY_FILES} DESTINATION "''${CMAKE_INSTALL_PREFIX}/bin")' ""
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'COMMAND ''${CMAKE_COMMAND} -E copy_directory "''${CMAKE_PREFIX_PATH}/libpython" "''${BIN_DIR}/python"' "" \
      --replace-fail 'orcaslicer_copy_sos(OrcaSlicerSosCopy "Release" "" output_sos_Release)' ""
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
    # Upstream builds its own sources with -Werror, which breaks with any compiler newer than upstream CI's
    (lib.cmakeBool "SLIC3R_WARNINGS" false)
    # Only needed to generate Python type stubs for plugin developers
    (lib.cmakeBool "ORCA_BUILD_PYTHON_STUBGEN_MODULE" false)
    # Used by the plugin system to install plugin dependencies; otherwise downloaded at configure time
    (lib.cmakeFeature "ORCA_BUNDLED_UV_EXECUTABLE" (lib.getExe uv))
    (lib.cmakeFeature "LIBNOISE_INCLUDE_DIR" "${libnoise}/include")
    (lib.cmakeFeature "LIBNOISE_LIBRARY_RELEASE" "${libnoise}/lib/libnoise-static.a")
    "-Wno-dev"
  ];

  # Generate translation files
  postBuild = "( cd .. && ./scripts/run_gettext.sh )";

  preFixup = ''
    gappsWrapperArgs+=(
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

    # Headers and CMake files installed by the vendored stb_dxt library
    rm -r $out/include $out/lib

    # The configured uv path is used at runtime; avoid shipping a second copy.
    ln -sf ${lib.getExe uv} $out/share/OrcaSlicer/tools/uv/uv
  '';

  passthru = {
    # SolveSpace constraint solver used by the Design tab, built the way upstream's
    # deps/SLVS does (upstream's own CMakeLists builds only a demo and installs nothing).
    slvs = clangStdenv.mkDerivation {
      pname = "orca-slicer-slvs";
      version = "0-unstable-2018-10-16";

      src = fetchFromGitHub {
        owner = "JacobStoren";
        repo = "SolveSpaceLib";
        rev = "4d8704523e4bf212fadf5189f92484244f670fea";
        hash = "sha256-xe6J+cnOUWLo5561CskQlR+3Co8FriCupc8l1lhhocA=";
      };

      postPatch = ''
        cp ${finalAttrs.src}/deps/SLVS/CMakeLists.txt.in CMakeLists.txt
      '';

      nativeBuildInputs = [ cmake ];

      meta = {
        description = "SolveSpace geometric constraint solver library, as used by OrcaSlicer";
        homepage = "https://github.com/JacobStoren/SolveSpaceLib";
        license = lib.licenses.gpl3Plus;
        platforms = lib.platforms.linux;
      };
    };
  };

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
