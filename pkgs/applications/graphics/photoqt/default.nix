{ mkDerivation, stdenv, fetchurl, cmake, exiv2, graphicsmagick, libraw, fetchpatch
, qtbase, qtdeclarative, qtmultimedia, qtquickcontrols, qttools, qtgraphicaleffects
, extra-cmake-modules, poppler, kimageformats, libarchive, libdevil
}:

mkDerivation rec {
  pname = "photoqt";
  version = "1.7.1";

  src = fetchurl {
    url = "https://${pname}.org/pkgs/${pname}-${version}.tar.gz";
    sha256 = "1qvxdh3cbjcywqx0da2qp8z092660qyzv5yknqbps2zr12qqb103";
  };

  patches = [
    # Fixes build with exiv2 0.27.1
    (fetchpatch {
      url = "https://gitlab.com/luspi/photoqt/commit/c6fd41478e818f3a651d40f96cab3d790e1c09a4.patch";
      sha256 = "1j2pdr7hm3js7lswhb4qkf9sj9viclhjqz50qxpyd7pqrl1gf2va";
    })
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules qttools ];

  buildInputs = [
    qtbase qtquickcontrols exiv2 graphicsmagick poppler
    qtmultimedia qtdeclarative libraw qtgraphicaleffects
    kimageformats libarchive
  ];

  cmakeFlags = [
    "-DFREEIMAGE=OFF"
    "-DDEVIL=OFF"
  ];

  preConfigure = ''
    export MAGICK_LOCATION="${graphicsmagick}/include/GraphicsMagick"
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = https://photoqt.org/;
    description = "Simple, yet powerful and good looking image viewer";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
