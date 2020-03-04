{ stdenv, lib, fetchFromGitHub, makeWrapper, cmake, pkgconfig
, boost, cereal, curl, eigen, expat, glew, libpng, tbb, wxGTK31
, gtest, nlopt, xorg, makeDesktopItem
}:
let
  nloptVersion = if lib.hasAttr "version" nlopt
                 then lib.getAttr "version" nlopt
                 else "2.4";
in
stdenv.mkDerivation rec {
  pname = "prusa-slicer";
  version = "2.1.1";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkgconfig
  ];

  buildInputs = [
    boost
    cereal
    curl
    eigen
    expat
    glew
    libpng
    tbb
    wxGTK31
    xorg.libX11
  ] ++ checkInputs;

  checkInputs = [ gtest ];

  # The build system uses custom logic - defined in
  # xs/src/libnest2d/cmake_modules/FindNLopt.cmake in the package source -
  # for finding the nlopt library, which doesn't pick up the package in the nix store.
  # We need to set the path via the NLOPT environment variable instead.
  NLOPT = nlopt;

  # Disable compiler warnings that clutter the build log
  # It seems to be a known issue for Eigen:
  # http://eigen.tuxfamily.org/bz/show_bug.cgi?id=1221
  NIX_CFLAGS_COMPILE = "-Wno-ignored-attributes";

  prePatch = ''
    # In nix ioctls.h isn't available from the standard kernel-headers package
    # like in other distributions. The copy in glibc seems to be identical to the
    # one in the kernel though, so we use that one instead.
    sed -i 's|"/usr/include/asm-generic/ioctls.h"|<asm-generic/ioctls.h>|g' src/libslic3r/GCodeSender.cpp
  '' + lib.optionalString (lib.versionOlder "2.5" nloptVersion) ''
    # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
    # now seems to be integrated into the main lib.
    sed -i 's|nlopt_cxx|nlopt|g' src/libnest2d/cmake_modules/FindNLopt.cmake
  '';

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "PrusaSlicer";
    sha256 = "0i393nbc2salb4j5l2hvy03ng7hmf90d2xj653pw9bsikhj0r3jd";
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
    categories = "Application;Development;";
  };

  meta = with stdenv.lib; {
    description = "G-code generator for 3D printer";
    homepage = https://github.com/prusa3d/PrusaSlicer;
    license = licenses.agpl3;
    maintainers = with maintainers; [ tweber ];
  };
}
