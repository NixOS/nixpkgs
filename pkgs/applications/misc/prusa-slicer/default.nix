{ stdenv
, lib
, binutils
, fetchFromGitHub
, cmake
, copyDesktopItems
, makeDesktopItem
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
, nlopt
, openvdb
, pcre
, qhull
, systemd
, tbb
, wxGTK31-gtk3
, xorg
, fetchpatch
, wxGTK31-gtk3-override ? null
}:
let
  wxGTK31-gtk3-prusa = wxGTK31-gtk3.overrideAttrs (old: rec {
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
  wxGTK31-gtk3-override' = if wxGTK31-gtk3-override == null then wxGTK31-gtk3-prusa else wxGTK31-gtk3-override;
in
stdenv.mkDerivation rec {
  pname = "prusa-slicer";
  version = "2.4.2";

  nativeBuildInputs = [
    cmake
    copyDesktopItems
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
    nlopt
    openvdb
    pcre
    systemd
    tbb
    wxGTK31-gtk3-override'
    xorg.libX11
  ] ++ checkInputs;

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
  NIX_LDFLAGS = "-ludev";

  prePatch = ''
    # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
    # now seems to be integrated into the main lib.
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake
  '';

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "PrusaSlicer";
    sha256 = "17p56f0zmiryy8k4da02in1l6yxniz286gf9yz8s1gaz5ksqj4af";
    rev = "version_${version}";
  };

  cmakeFlags = [
    "-DSLIC3R_FHS=1"
    "-DSLIC3R_GTK=3"
  ];

  postInstall = ''
    ln -s "$out/bin/prusa-slicer" "$out/bin/prusa-gcodeviewer"

    mkdir -p "$out/share/pixmaps/"
    ln -s "$out/share/PrusaSlicer/icons/PrusaSlicer.png" "$out/share/pixmaps/PrusaSlicer.png"
    ln -s "$out/share/PrusaSlicer/icons/PrusaSlicer-gcodeviewer_192px.png" "$out/share/pixmaps/PrusaSlicer-gcodeviewer.png"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "prusa-slicer";
      exec = "prusa-slicer";
      icon = "PrusaSlicer";
      comment = "G-code generator for 3D printers";
      desktopName = "PrusaSlicer";
      genericName = "3D printer tool";
      categories = [ "Development" ];
    })
    (makeDesktopItem {
      name = "prusa-gcodeviewer";
      exec = "prusa-gcodeviewer";
      icon = "PrusaSlicer-gcodeviewer";
      comment = "G-code viewer for 3D printers";
      desktopName = "PrusaSlicer G-code Viewer";
      genericName = "G-code Viewer";
      categories = [ "Development" ];
    })
  ];

  meta = with lib; {
    description = "G-code generator for 3D printer";
    homepage = "https://github.com/prusa3d/PrusaSlicer";
    license = licenses.agpl3;
    maintainers = with maintainers; [ moredread tweber ];
  };
}
