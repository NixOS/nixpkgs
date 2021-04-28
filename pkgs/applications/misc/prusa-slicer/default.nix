{ stdenv, lib, fetchFromGitHub, cmake, copyDesktopItems, makeDesktopItem, pkg-config, wrapGAppsHook
, boost, cereal, cgal_5, curl, dbus, eigen, expat, glew, glib, gmp, gtest, gtk3, hicolor-icon-theme
, ilmbase, libpng, mpfr, nlopt, openvdb, pcre, qhull, systemd, tbb, wxGTK31-gtk3, xorg
}:
stdenv.mkDerivation rec {
  pname = "prusa-slicer";
  version = "2.3.1";

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
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
    wxGTK31-gtk3
    xorg.libX11
  ] ++ checkInputs;

  doCheck = true;
  checkInputs = [ gtest ];

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
    # In nix ioctls.h isn't available from the standard kernel-headers package
    # like in other distributions. The copy in glibc seems to be identical to the
    # one in the kernel though, so we use that one instead.
    sed -i 's|"/usr/include/asm-generic/ioctls.h"|<asm-generic/ioctls.h>|g' src/libslic3r/GCodeSender.cpp

    # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
    # now seems to be integrated into the main lib.
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake
  '';

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "PrusaSlicer";
    sha256 = "1lyaxc9nha1cd8p35iam1k1pikp9kfx0fj1l6vb1xb8pgqp02jnn";
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
      name = "PrusaSlicer";
      exec = "prusa-slicer";
      icon = "PrusaSlicer";
      comment = "G-code generator for 3D printers";
      desktopName = "PrusaSlicer";
      genericName = "3D printer tool";
      categories = "Development;";
    })
    (makeDesktopItem {
      name = "PrusaSlicer G-code Viewer";
      exec = "prusa-gcodeviewer";
      icon = "PrusaSlicer-gcodeviewer";
      comment = "G-code viewer for 3D printers";
      desktopName = "PrusaSlicer G-code Viewer";
      genericName = "G-code Viewer";
      categories = "Development;";
    })
  ];

  meta = with lib; {
    description = "G-code generator for 3D printer";
    homepage = "https://github.com/prusa3d/PrusaSlicer";
    license = licenses.agpl3;
    maintainers = with maintainers; [ moredread tweber ];
  };
}
