{ stdenv, fetchFromGitHub, unzip, ftgl, glew, asciidoc
, cmake, mesa, zlib, python, expat, libxml2, libsigcxx, libuuid, freetype
, libpng, boost, doxygen, cairomm, pkgconfig, imagemagick, libjpeg, libtiff
, gettext, intltool, perl, gtkmm, glibmm, gtkglext, pangox_compat, libXmu }:

stdenv.mkDerivation rec {
  version = "0.8.0.5";
  name = "k3d-${version}";
  src = fetchFromGitHub {
    owner = "K-3D";
    repo = "k3d";
    rev = name;
    sha256 = "0q05d51vhnmrq887n15frpwkhx8w7n20h2sc1lpr338jzpryihb3";
  };
  
  cmakeFlags = "-DK3D_BUILD_DOCS=false -DK3D_BUILD_GUIDE=false";

  preConfigure = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/build/lib"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE  -I$(echo ${gtkglext}/include/gtkglext-*) -I$(echo ${gtkglext}/lib/gtkglext-*/include)"
  '';

  buildInputs = [
     cmake mesa zlib python expat libxml2 libsigcxx libuuid freetype libpng
     boost boost doxygen cairomm pkgconfig imagemagick libjpeg libtiff
     gettext intltool perl unzip ftgl glew asciidoc
     gtkmm glibmm gtkglext pangox_compat libXmu
    ];

  #doCheck = false;

  enableParallelBuilding = true;

  meta = {
    description = "A 3D editor with support for procedural editing";
    homepage = "http://k-3d.org/";
    platforms = with stdenv.lib.platforms;
      linux;
    maintainers = with stdenv.lib.maintainers;
      [raskin];
  };
}
