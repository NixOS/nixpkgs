{ stdenv, fetchFromGitHub, fetchpatch, unzip, ftgl, glew, asciidoc
, cmake, mesa, zlib, python, expat, libxml2, libsigcxx, libuuid, freetype
, libpng, boost, doxygen, cairomm, pkgconfig, imagemagick, libjpeg, libtiff
, gettext, intltool, perl, gtkmm2, glibmm, gtkglext, pangox_compat, libXmu }:

stdenv.mkDerivation rec {
  version = "0.8.0.6";
  name = "k3d-${version}";
  src = fetchFromGitHub {
    owner = "K-3D";
    repo = "k3d";
    rev = name;
    sha256 = "0vdjjg6h8mxm2n8mvkkg2mvd27jn2xx90hnmx23cbd35mpz9p4aa";
  };

  patches = [
    (fetchpatch { /* glibmm 2.50 fix */
      url = https://github.com/K-3D/k3d/commit/c65889d0652490d88a573e47de7a9324bf27bff2.patch;
      sha256 = "162icv1hicr2dirkb9ijacvg9bhz5j30yfwg7b45ijavk8rns62j";
    })
  ];

  cmakeFlags = "-DK3D_BUILD_DOCS=false -DK3D_BUILD_GUIDE=false";

  preConfigure = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/build/lib"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE  -I$(echo ${gtkglext}/include/gtkglext-*) -I$(echo ${gtkglext}/lib/gtkglext-*/include)"
  '';

  buildInputs = [
     cmake mesa zlib python expat libxml2 libsigcxx libuuid freetype libpng
     boost doxygen cairomm pkgconfig imagemagick libjpeg libtiff
     gettext intltool perl unzip ftgl glew asciidoc
     gtkmm2 glibmm gtkglext pangox_compat libXmu
    ];

  #doCheck = false;

  enableParallelBuilding = true;

  meta = {
    description = "A 3D editor with support for procedural editing";
    homepage = http://www.k-3d.org/;
    platforms = with stdenv.lib.platforms;
      linux;
    maintainers = with stdenv.lib.maintainers;
      [raskin];
  };
}
