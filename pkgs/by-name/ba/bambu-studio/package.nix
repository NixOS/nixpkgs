{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  boost183,
  cacert,
  cereal,
  cgal_5,
  curl,
  dbus,
  eigen,
  expat,
  ffmpeg,
  glew,
  glfw,
  glib,
  glib-networking,
  gmp,
  gst_all_1,
  gtest,
  gtk3,
  hicolor-icon-theme,
  libpng,
  libsecret,
  makeFontsConf,
  libnoise,
  mpfr,
  nanum,
  nlopt,
  opencascade-occt_7_6,
  openvdb,
  openexr,
  opencv,
  systemd,
  onetbb,
  webkitgtk_4_1,
  wxwidgets_3_1,
  libx11,
  withSystemd ? stdenv.hostPlatform.isLinux,
  # 3D viewport blank on NVIDIA proprietary GL; routes through Mesa + zink.
  # https://github.com/NixOS/nixpkgs/issues/498311
  withNvidiaGLWorkaround ? false,
}:
let
  wxGTK' =
    (wxwidgets_3_1.override {
      withCurl = true;
      withPrivateFonts = true;
      withWebKit = true;
    }).overrideAttrs
      (old: {
        buildInputs = old.buildInputs ++ [ libsecret ];
        configureFlags = old.configureFlags ++ [
          # Disable noisy debug dialogs
          "--enable-debug=no"
          "--enable-secretstore"
        ];
      });

  fontsConf = makeFontsConf { fontDirectories = [ nanum ]; };

  caBundle = "${cacert}/etc/ssl/certs/ca-bundle.crt";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bambu-studio";
  version = "02.06.01.55";

  src = fetchFromGitHub {
    owner = "bambulab";
    repo = "BambuStudio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k+t6zwjUQ6y4vAIhQSEnsGDzbxw/ouyslQypbloWIII=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    boost183
    cereal
    cgal_5
    curl
    dbus
    eigen
    expat
    ffmpeg
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
    libpng
    libsecret
    libnoise
    mpfr
    nlopt
    opencascade-occt_7_6
    openexr
    openvdb
    onetbb
    webkitgtk_4_1
    wxGTK'
    libx11
    opencv
  ]
  ++ lib.optionals withSystemd [ systemd ]
  ++ finalAttrs.checkInputs;

  patches = [
    # Fix for webkitgtk linking
    ./patches/0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch
    # Fix an issue with
    ./patches/dont-link-opencv-world-bambu.patch
    # Don't link osmesa
    ./patches/no-osmesa.patch
    # Don't link cereal
    ./patches/no-cereal.patch
    # Cmake 4 support
    ./patches/cmake.patch
  ];

  doCheck = true;
  checkInputs = [ gtest ];

  separateDebugInfo = true;

  env = {
    # The build system uses custom logic - defined in
    # cmake/modules/FindNLopt.cmake in the package source - for finding the nlopt
    # library, which doesn't pick up the package in the nix store.  We
    # additionally need to set the path via the NLOPT environment variable.
    NLOPT = nlopt;

    NIX_CFLAGS_COMPILE = toString [
      "-DBOOST_TIMER_ENABLE_DEPRECATED"
      # Disable compiler warnings that clutter the build log.
      # It seems to be a known issue for Eigen:
      # http://eigen.tuxfamily.org/bz/show_bug.cgi?id=1221
      "-Wno-ignored-attributes"
      "-I${opencv}/include/opencv4"
    ];

    # prusa-slicer uses dlopen on `libudev.so` at runtime
    NIX_LDFLAGS = lib.optionalString withSystemd "-ludev" + " -L${opencv}/lib -lopencv_imgcodecs";
  };

  # TODO: macOS
  prePatch = ''
    # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
    # now seems to be integrated into the main lib.
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake
  '';

  cmakeFlags = [
    (lib.cmakeBool "SLIC3R_STATIC" false)
    (lib.cmakeBool "SLIC3R_FHS" true)
    (lib.cmakeFeature "SLIC3R_GTK" "3")

    # Skips installing ffmpeg, since we BYO.
    (lib.cmakeBool "FLATPAK" true)

    # Substituted into `#define BBL_x @value@`; must be integer literals.
    (lib.cmakeFeature "BBL_RELEASE_TO_PUBLIC" "1")
    (lib.cmakeFeature "BBL_INTERNAL_TESTING" "0")
    (lib.cmakeBool "DEP_WX_GTK3" true)
    (lib.cmakeBool "SLIC3R_BUILD_TESTS" false)
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DBOOST_LOG_DYN_LINK")

    (lib.cmakeFeature "LIBNOISE_INCLUDE_DIR" "${libnoise}/include")
    (lib.cmakeFeature "LIBNOISE_LIBRARY" "${libnoise}/lib/libnoise-static.a")
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib"

      # Fixes intermittent crash
      # The upstream setup links in glew statically
      --prefix LD_PRELOAD : "${glew.out}/lib/libGLEW.so"

      # plugin libcurl + main HTTPS need explicit CA bundle.
      # https://github.com/NixOS/nixpkgs/issues/498307
      --set-default SSL_CERT_FILE ${caBundle}
      --set-default CURL_CA_BUNDLE ${caBundle}

      # WebKit OAuth callback fails with DMA-BUF compositing.
      # https://github.com/NixOS/nixpkgs/issues/498307
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1

      --set FONTCONFIG_FILE "${fontsConf}"

      ${lib.optionalString withNvidiaGLWorkaround ''
        --set __GLX_VENDOR_LIBRARY_NAME mesa
        --set __EGL_VENDOR_LIBRARY_FILENAMES /run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json
        --set MESA_LOADER_DRIVER_OVERRIDE zink
        --set GALLIUM_DRIVER zink
      ''}
    )
  '';

  # needed to prevent collisions between the LICENSE.txt files of
  # bambu-studio and orca-slicer.
  postInstall = ''
    mv $out/LICENSE.txt $out/share/BambuStudio/LICENSE.txt
    mv $out/README.md $out/share/BambuStudio/README.md
  '';

  meta = {
    description = "PC Software for BambuLab's 3D printers";
    homepage = "https://github.com/bambulab/BambuStudio";
    changelog = "https://github.com/bambulab/BambuStudio/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      agpl3Plus
      # Bambu Studio downloads and dlopens a proprietary networking library
      # at first launch whose corresponding source is not provided. SFC ruled
      # this an ongoing AGPLv3 violation; see:
      # https://github.com/NixOS/nixpkgs/issues/415821
      # https://sfconservancy.org/news/2026/may/18/bambu-studio-3d-printer-agpl-violation-response/
      unfree
    ];
    maintainers = with lib.maintainers; [
      zhaofengli
      dsluijk
      miniharinn
    ];
    mainProgram = "bambu-studio";
    platforms = lib.platforms.linux;
  };
})
