{
  stdenv,
  lib,
  binutils,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  boost180,
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
  pname = "bambu-studio";
  version = "01.10.01.50";

  src = fetchFromGitHub {
    owner = "bambulab";
    repo = "BambuStudio";
    rev = "v${version}";
    hash = "sha256-7mkrPl2CQSfc1lRjl1ilwxdYcK5iRU//QGKmdCicK30=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    binutils
    boost180
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
    mesa.osmesa
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
  ] ++ lib.optionals withSystemd [ systemd ] ++ checkInputs;

  patches = [
    # Fix for webkitgtk linking
    ./patches/0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch
    # Fix an issue with
    ./patches/dont-link-opencv-world-bambu.patch
  ];

  doCheck = true;
  checkInputs = [ gtest ];

  separateDebugInfo = true;

  # The build system uses custom logic - defined in
  # cmake/modules/FindNLopt.cmake in the package source - for finding the nlopt
  # library, which doesn't pick up the package in the nix store.  We
  # additionally need to set the path via the NLOPT environment variable.
  NLOPT = nlopt;

  # Disable compiler warnings that clutter the build log.
  # It seems to be a known issue for Eigen:
  # http://eigen.tuxfamily.org/bz/show_bug.cgi?id=1221
  NIX_CFLAGS_COMPILE = toString [
    "-Wno-ignored-attributes"
    "-I${opencv.out}/include/opencv4"
  ];

  # prusa-slicer uses dlopen on `libudev.so` at runtime
  NIX_LDFLAGS = lib.optionalString withSystemd "-ludev";

  # TODO: macOS
  prePatch = ''
    # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
    # now seems to be integrated into the main lib.
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake
  '';

  cmakeFlags = [
    "-DSLIC3R_STATIC=0"
    "-DSLIC3R_FHS=1"
    "-DSLIC3R_GTK=3"

    # Skips installing ffmpeg, since we BYO.
    "-DFLATPAK=1"

    # BambuStudio-specific
    "-DBBL_RELEASE_TO_PUBLIC=1"
    "-DBBL_INTERNAL_TESTING=0"
    "-DDEP_WX_GTK3=ON"
    "-DSLIC3R_BUILD_TESTS=0"
    "-DCMAKE_CXX_FLAGS=-DBOOST_LOG_DYN_LINK"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib"

      # Fixes intermittent crash
      # The upstream setup links in glew statically
      --prefix LD_PRELOAD : "${glew.out}/lib/libGLEW.so"
    )
  '';

  # needed to prevent collisions between the LICENSE.txt files of
  # bambu-studio and orca-slicer.
  postInstall = ''
    mv $out/LICENSE.txt $out/share/BambuStudio/LICENSE.txt
    mv $out/README.md $out/share/BambuStudio/README.md
  '';

  meta = with lib; {
    description = "PC Software for BambuLab's 3D printers";
    homepage = "https://github.com/bambulab/BambuStudio";
    changelog = "https://github.com/bambulab/BambuStudio/releases/tag/v${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      zhaofengli
      dsluijk
    ];
    mainProgram = "bambu-studio";
    platforms = platforms.linux;
  };
}
