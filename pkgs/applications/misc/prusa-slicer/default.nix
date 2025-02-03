{ stdenv
, lib
, binutils
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, wrapGAppsHook3
, boost
, cereal
, cgal
, curl
, darwin
, dbus
, eigen
, expat
, glew
, glib
, glib-networking
, gmp
, gtk3
, hicolor-icon-theme
, ilmbase
, libpng
, mpfr
, nanosvg
, nlopt
, opencascade-occt_7_6
, openvdb
, pcre
, qhull
, tbb_2021_11
, wxGTK32
, xorg
, libbgcode
, heatshrink
, catch2
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
, wxGTK-override ? null
}:
let
  opencascade-occt = opencascade-occt_7_6;
  wxGTK-prusa = wxGTK32.overrideAttrs (old: rec {
    pname = "wxwidgets-prusa3d-patched";
    version = "3.2.0";
    configureFlags = old.configureFlags ++ [ "--disable-glcanvasegl" ];
    patches = [ ./wxWidgets-Makefile.in-fix.patch ];
    src = fetchFromGitHub {
      owner = "prusa3d";
      repo = "wxWidgets";
      rev = "78aa2dc0ea7ce99dc19adc1140f74c3e2e3f3a26";
      hash = "sha256-rYvmNmvv48JSKVT4ph9AS+JdstnLSRmcpWz1IdgBzQo=";
      fetchSubmodules = true;
    };
  });
  nanosvg-fltk = nanosvg.overrideAttrs (old: rec {
    pname = "nanosvg-fltk";
    version = "unstable-2022-12-22";

    src = fetchFromGitHub {
      owner = "fltk";
      repo = "nanosvg";
      rev = "abcd277ea45e9098bed752cf9c6875b533c0892f";
      hash = "sha256-WNdAYu66ggpSYJ8Kt57yEA4mSTv+Rvzj9Rm1q765HpY=";
    };
  });
  openvdb_tbb_2021_8 = openvdb.override { tbb = tbb_2021_11; };
  wxGTK-override' = if wxGTK-override == null then wxGTK-prusa else wxGTK-override;

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/master/media-gfx/prusaslicer/files/prusaslicer-2.8.0-missing-includes.patch";
      hash = "sha256-/R9jv9zSP1lDW6IltZ8V06xyLdxfaYrk3zD6JRFUxHg=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/master/media-gfx/prusaslicer/files/prusaslicer-2.8.0-fixed-linking.patch";
      hash = "sha256-G1JNdVH+goBelag9aX0NctHFVqtoYFnqjwK/43FVgvM=";
    })
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prusa-slicer";
  version = "2.8.0";
  inherit patches;

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "PrusaSlicer";
    hash = "sha256-A/uxNIEXCchLw3t5erWdhqFAeh6nudcMfASi+RoJkFg=";
    rev = "version_${finalAttrs.version}";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    binutils
    boost
    cereal
    cgal
    curl
    dbus
    eigen
    expat
    glew
    glib
    glib-networking
    gmp
    gtk3
    hicolor-icon-theme
    ilmbase
    libpng
    mpfr
    nanosvg-fltk
    nlopt
    opencascade-occt
    openvdb_tbb_2021_8
    pcre
    qhull
    tbb_2021_11
    wxGTK-override'
    xorg.libX11
    libbgcode
    heatshrink
    catch2
  ] ++ lib.optionals withSystemd [
    systemd
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreWLAN
  ];

  separateDebugInfo = true;

  # The build system uses custom logic - defined in
  # cmake/modules/FindNLopt.cmake in the package source - for finding the nlopt
  # library, which doesn't pick up the package in the nix store.  We
  # additionally need to set the path via the NLOPT environment variable.
  NLOPT = nlopt;

  # prusa-slicer uses dlopen on `libudev.so` at runtime
  NIX_LDFLAGS = lib.optionalString withSystemd "-ludev";

  prePatch = ''
    # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
    # now seems to be integrated into the main lib.
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake

    # Disable slic3r_jobs_tests.cpp as the test fails sometimes
    sed -i 's|slic3r_jobs_tests.cpp||g' tests/slic3rutils/CMakeLists.txt

    # prusa-slicer expects the OCCTWrapper shared library in the same folder as
    # the executable when loading STEP files. We force the loader to find it in
    # the usual locations (i.e. LD_LIBRARY_PATH) instead. See the manpage
    # dlopen(3) for context.
    if [ -f "src/libslic3r/Format/STEP.cpp" ]; then
      substituteInPlace src/libslic3r/Format/STEP.cpp \
        --replace 'libpath /= "OCCTWrapper.so";' 'libpath = "OCCTWrapper.so";'
    fi
    # https://github.com/prusa3d/PrusaSlicer/issues/9581
    if [ -f "cmake/modules/FindEXPAT.cmake" ]; then
      rm cmake/modules/FindEXPAT.cmake
    fi

    # Fix resources folder location on macOS
    substituteInPlace src/PrusaSlicer.cpp \
      --replace "#ifdef __APPLE__" "#if 0"
  '';

  cmakeFlags = [
    "-DSLIC3R_STATIC=0"
    "-DSLIC3R_FHS=1"
    "-DSLIC3R_GTK=3"
  ];

  postInstall = ''
    ln -s "$out/bin/prusa-slicer" "$out/bin/prusa-gcodeviewer"

    mkdir -p "$out/lib"
    mv -v $out/bin/*.* $out/lib/

    mkdir -p "$out/share/pixmaps/"
    ln -s "$out/share/PrusaSlicer/icons/PrusaSlicer.png" "$out/share/pixmaps/PrusaSlicer.png"
    ln -s "$out/share/PrusaSlicer/icons/PrusaSlicer-gcodeviewer_192px.png" "$out/share/pixmaps/PrusaSlicer-gcodeviewer.png"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib"
    )
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ctest \
      --force-new-ctest-process \
      -E 'libslic3r_tests|sla_print_tests'

    runHook postCheck
  '';

  meta = with lib; {
    description = "G-code generator for 3D printer";
    homepage = "https://github.com/prusa3d/PrusaSlicer";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ moredread tweber tmarkus ];
    platforms = platforms.unix;
  } // lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
    mainProgram = "PrusaSlicer";
  };
})
