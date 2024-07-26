{ stdenv
, lib
, openexr
, jemalloc
, c-blosc
, binutils
, fetchFromGitHub
, cmake
, pkg-config
, wrapGAppsHook
, boost179
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
, gst-plugins-good
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
, tbb_2021_8
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
  openvdb_tbb_2021_8 = openvdb.overrideAttrs (old: rec {
    buildInputs = [ openexr boost179 tbb_2021_8 jemalloc c-blosc ilmbase ];
  });
in
stdenv.mkDerivation rec {
  pname = "bambu-studio";
  version = "01.08.04.51";

  src = fetchFromGitHub {
    owner = "bambulab";
    repo = "BambuStudio";
    rev = "v${version}";
    hash = "sha256-rqD1+3Q4ZUBgS57iCItuLX6ZMP7VQuedaJmgKB1szgs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    binutils
    boost179
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
    gst-plugins-good
    gtk3
    hicolor-icon-theme
    ilmbase
    libpng
    mesa.osmesa
    mpfr
    nlopt
    opencascade-occt
    openvdb_tbb_2021_8
    pcre
    tbb_2021_8
    webkitgtk
    wxGTK31'
    xorg.libX11
  ] ++ lib.optionals withSystemd [
    systemd
  ] ++ checkInputs;

  patches = [
    # Fix for webkitgtk linking
    ./0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch
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
    platforms = platforms.linux;
  };
}
