{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig
, boost, cereal, curl, eigen, expat, glew, libpng, tbb, wxGTK31
, gtest, nlopt, xorg, makeDesktopItem
, cgal_5, gmp, ilmbase, mpfr, qhull, openvdb, systemd
}:
stdenv.mkDerivation rec {
  pname = "prusa-slicer";
  version = "2.2.0";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    boost
    cereal
    cgal_5
    curl
    eigen
    expat
    glew
    gmp
    ilmbase
    libpng
    mpfr
    nlopt
    openvdb
    systemd
    tbb
    wxGTK31
    xorg.libX11
  ] ++ checkInputs;

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
    sha256 = "0954k9sm09y8qnz1jyswyysg10k54ywz8mswnwa4n2hnpq9qx73m";
    rev = "version_${version}";
  };

  cmakeFlags = [
    "-DSLIC3R_FHS=1"
  ];

  postInstall = ''
    mkdir -p "$out/share/pixmaps/"
    ln -s "$out/share/PrusaSlicer/icons/PrusaSlicer.png" "$out/share/pixmaps/PrusaSlicer.png"
    mkdir -p "$out/share/applications"
    cp "$desktopItem"/share/applications/* "$out/share/applications/"
  '';

  desktopItem = makeDesktopItem {
    name = "PrusaSlicer";
    exec = "prusa-slicer";
    icon = "PrusaSlicer";
    comment = "G-code generator for 3D printers";
    desktopName = "PrusaSlicer";
    genericName = "3D printer tool";
    categories = "Development;";
  };

  meta = with stdenv.lib; {
    description = "G-code generator for 3D printer";
    homepage = "https://github.com/prusa3d/PrusaSlicer";
    license = licenses.agpl3;
    maintainers = with maintainers; [ moredread tweber ];
  };
}
