{ stdenv, fetchurl, unzip, ftgl, glew, asciidoc
, cmake, mesa, zlib, python, expat, libxml2, libsigcxx, libuuid, freetype
, libpng, boost, doxygen, cairomm, pkgconfig, imagemagick, libjpeg, libtiff
, gettext, intltool, perl, gtkmm, glibmm, gtkglext, pangox_compat, libXmu }:

stdenv.mkDerivation rec {
  version = "0.8.0.3";
  name = "k3d-${version}";
  src = fetchurl {
    url = "https://github.com/K-3D/k3d/archive/${name}.zip";
    sha256 = "09ywwvlk8hh1357pnal96kc40ma4jq7776hqk0609rgz13s6babp";
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
