{ stdenv
, lib
, binutils
, fetchFromGitHub
, cmake
, pkg-config
, wrapGAppsHook
, boost
, cereal
, cgal_5
, curl
, dbus
, eigen
, expat
, gcc-unwrapped
, glew
, glfw
, glib
, glib-networking
, gmp
, gstreamer
, gst-plugins-base
, gst-plugins-bad
, gtest
, gtk3
, hicolor-icon-theme
, ilmbase
, libpng
, mesa
, mpfr
, nlopt
, opencascade-occt
, openvdb
, pcre
, qhull
, systemd
, tbb
, webkitgtk
, wxGTK31
, xorg
, fetchpatch
, withSystemd ? stdenv.isLinux
}:
let
  wxGTK31' = wxGTK31.overrideAttrs (old: {
    configureFlags = old.configureFlags ++ [
      # Disable noisy debug dialogs
      "--enable-debug=no"
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "bambu-studio";
  version = "01.06.02.04";

  src = fetchFromGitHub {
    owner = "bambulab";
    repo = "BambuStudio";
    rev = "v${version}";
    hash = "sha256-k2/0ukIVjGhUUKhaJCldTRsQcHwX/mL2ROVaiTkv/eg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    binutils
    boost
    cereal
    cgal_5
    curl
    dbus
    eigen
    expat
    gcc-unwrapped
    glew
    glfw
    glib
    glib-networking
    gmp
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gtk3
    hicolor-icon-theme
    ilmbase
    libpng
    mesa.osmesa
    mpfr
    nlopt
    opencascade-occt
    openvdb
    pcre
    tbb
    webkitgtk
    wxGTK31'
    xorg.libX11
  ] ++ lib.optionals withSystemd [
    systemd
  ] ++ checkInputs;

  patches = [
    # Fix for webkitgtk linking
    ./0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch

    # Fix null pointer deref with wxTranslations::Get()
    #
    # https://github.com/bambulab/BambuStudio/pull/1906
    (fetchpatch {
      name = "Initialize-locale-before-wxTranslations-Get.patch";
      url = "https://github.com/zhaofengli/BambuStudio/commit/04728a14433ebd3b36032210c1ef806c63101166.patch";
      hash = "sha256-9rk/qaDMqqN9aaK0E1ElKz1qUkznOEBlgeMSE48wQh8=";
    })
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
  NIX_CFLAGS_COMPILE = "-Wno-ignored-attributes";

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

  meta = with lib; {
    description = "PC Software for BambuLab's 3D printers";
    homepage = "https://github.com/bambulab/BambuStudio";
    license = licenses.agpl3;
    maintainers = with maintainers; [ zhaofengli ];
    mainProgram = "bambu-studio";
  };
}
