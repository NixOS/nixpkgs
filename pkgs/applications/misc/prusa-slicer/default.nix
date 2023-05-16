{ stdenv
, lib
<<<<<<< HEAD
, openexr
, jemalloc
, c-blosc
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
, glew
, glib
, gmp
, gtest
, gtk3
, hicolor-icon-theme
, ilmbase
, libpng
, mpfr
<<<<<<< HEAD
, nanosvg
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nlopt
, opencascade-occt
, openvdb
, pcre
, qhull
<<<<<<< HEAD
, tbb_2021_8
, wxGTK32
, xorg
, fetchpatch
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
, wxGTK-override ? null
}:
let
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
  openvdb_tbb_2021_8 = openvdb.overrideAttrs (old: rec {
    buildInputs = [ openexr boost tbb_2021_8 jemalloc c-blosc ilmbase ];
  });
  wxGTK-override' = if wxGTK-override == null then wxGTK-prusa else wxGTK-override;
in
stdenv.mkDerivation rec {
  pname = "prusa-slicer";
  version = "2.6.0";
=======
, tbb
, wxGTK31
, xorg
, fetchpatch
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
}:
let
  wxGTK-prusa = wxGTK31.overrideAttrs (old: rec {
    pname = "wxwidgets-prusa3d-patched";
    version = "3.1.4";
    src = fetchFromGitHub {
      owner = "prusa3d";
      repo = "wxWidgets";
      rev = "489f6118256853cf5b299d595868641938566cdb";
      hash = "sha256-xGL5I2+bPjmZGSTYe1L7VAmvLHbwd934o/cxg9baEvQ=";
      fetchSubmodules = true;
    };
  });
in
stdenv.mkDerivation rec {
  pname = "prusa-slicer";
  version = "2.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    glew
    glib
    gmp
    gtk3
    hicolor-icon-theme
    ilmbase
    libpng
    mpfr
<<<<<<< HEAD
    nanosvg-fltk
    nlopt
    opencascade-occt
    openvdb_tbb_2021_8
    pcre
    qhull
    tbb_2021_8
    wxGTK-override'
=======
    nlopt
    opencascade-occt
    openvdb
    pcre
    tbb
    wxGTK-prusa
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    xorg.libX11
  ] ++ lib.optionals withSystemd [
    systemd
  ] ++ nativeCheckInputs;

<<<<<<< HEAD
=======
  patches = [
    # Fix detection of TBB, see https://github.com/prusa3d/PrusaSlicer/issues/6355
    (fetchpatch {
      url = "https://github.com/prusa3d/PrusaSlicer/commit/76f4d6fa98bda633694b30a6e16d58665a634680.patch";
      sha256 = "1r806ycp704ckwzgrw1940hh1l6fpz0k1ww3p37jdk6mygv53nv6";
    })
    # Fix compile error with boost 1.79. See https://github.com/prusa3d/PrusaSlicer/issues/8238
    # Can be removed with the next version update
    (fetchpatch {
      url = "https://github.com/prusa3d/PrusaSlicer/commit/408e56f0390f20aaf793e0aa0c70c4d9544401d4.patch";
      sha256 = "sha256-vzEPjLE3Yy5szawPn2Yp3i7MceWewpdnLUPVu9+H3W8=";
    })
    (fetchpatch {
      url = "https://github.com/prusa3d/PrusaSlicer/commit/926ae0471800abd1e5335e251a5934570eb8f6ff.patch";
      sha256 = "sha256-tAEgubeGGKFWY7r7p/6pmI2HXUGKi2TM1X5ILVZVT20=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = true;
  nativeCheckInputs = [ gtest ];

  separateDebugInfo = true;

  # The build system uses custom logic - defined in
  # cmake/modules/FindNLopt.cmake in the package source - for finding the nlopt
  # library, which doesn't pick up the package in the nix store.  We
  # additionally need to set the path via the NLOPT environment variable.
  NLOPT = nlopt;

  # Disable compiler warnings that clutter the build log.
  # It seems to be a known issue for Eigen:
  # http://eigen.tuxfamily.org/bz/show_bug.cgi?id=1221
  env.NIX_CFLAGS_COMPILE = "-Wno-ignored-attributes";

  # prusa-slicer uses dlopen on `libudev.so` at runtime
  NIX_LDFLAGS = lib.optionalString withSystemd "-ludev";

  prePatch = ''
    # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
    # now seems to be integrated into the main lib.
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake

<<<<<<< HEAD
    # Disable slic3r_jobs_tests.cpp as the test fails sometimes
    sed -i 's|slic3r_jobs_tests.cpp||g' tests/slic3rutils/CMakeLists.txt
=======
    # Disable test_voronoi.cpp as the assembler hangs during build,
    # likely due to commit e682dd84cff5d2420fcc0a40508557477f6cc9d3
    # See issue #185808 for details.
    sed -i 's|test_voronoi.cpp||g' tests/libslic3r/CMakeLists.txt
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    # prusa-slicer expects the OCCTWrapper shared library in the same folder as
    # the executable when loading STEP files. We force the loader to find it in
    # the usual locations (i.e. LD_LIBRARY_PATH) instead. See the manpage
    # dlopen(3) for context.
    if [ -f "src/libslic3r/Format/STEP.cpp" ]; then
      substituteInPlace src/libslic3r/Format/STEP.cpp \
        --replace 'libpath /= "OCCTWrapper.so";' 'libpath = "OCCTWrapper.so";'
    fi
<<<<<<< HEAD
    # https://github.com/prusa3d/PrusaSlicer/issues/9581
    if [ -f "cmake/modules/FindEXPAT.cmake" ]; then
      rm cmake/modules/FindEXPAT.cmake
    fi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    # Fix resources folder location on macOS
    substituteInPlace src/PrusaSlicer.cpp \
      --replace "#ifdef __APPLE__" "#if 0"
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    # Disable segfault tests
    sed -i '/libslic3r/d' tests/CMakeLists.txt
  '';

<<<<<<< HEAD
  patches = [
    # wxWidgets: CheckResizerFlags assert fix
    (fetchpatch {
      url = "https://github.com/prusa3d/PrusaSlicer/commit/24a5ebd65c9d25a0fd69a3716d079fd1b00eb15c.patch";
      hash = "sha256-MNGtaI7THu6HEl9dMwcO1hkrCtIkscoNh4ulA2cKtZA=";
    })
  ];

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "PrusaSlicer";
    hash = "sha256-6AZdwNcgddHePyB0bNS7xGmpz38uzhAwUxgo48OQLuU=";
=======
  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "PrusaSlicer";
    sha256 = "sha256-oQRBVAbA2wOYZkQiYIgbd3UcKAkXjnNXo6gB5QbPDAs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    rev = "version_${version}";
  };

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

  meta = with lib; {
    description = "G-code generator for 3D printer";
    homepage = "https://github.com/prusa3d/PrusaSlicer";
    license = licenses.agpl3;
    maintainers = with maintainers; [ moredread tweber ];
  } // lib.optionalAttrs (stdenv.isDarwin) {
    mainProgram = "PrusaSlicer";
  };
}
