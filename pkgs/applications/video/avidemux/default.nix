{stdenv, fetchurl, cmake, pkgconfig, libxml2, qt4, gtk, gettext, SDL,
libXv, pixman, libpthreadstubs, libXau, libXdmcp, libxslt, x264,
alsaLib, lame, faac, faad2, libvorbis }:

assert stdenv ? glibc;

stdenv.mkDerivation {
  name = "avidemux-2.5.2";
  
  src = fetchurl {
    url = mirror://sourceforge/avidemux/avidemux_2.5.2.tar.gz;
    sha256 = "1apq5s79ik562xmhyvg6nvkmk2bhm5fcjwsrwrpxwipn6swkfpk8";
  };
  
  buildInputs = [ cmake pkgconfig libxml2 qt4 gtk gettext SDL libXv
    pixman libpthreadstubs libXau libXdmcp libxslt x264 alsaLib 
    lame faac faad2 libvorbis ];

  cmakeFlags = "-DPTHREAD_INCLUDE_DIR=${stdenv.glibc}/include" +
    " -DGETTEXT_INCLUDE_DIR=${gettext}/include" +
    " -DSDL_INCLUDE_DIR=${SDL}/include/SDL";

  NIX_LDFLAGS="-lpthread";

  postInstall = ''
    cd $NIX_BUILD_TOP/$sourceRoot
    mkdir build_plugins
    cd build_plugins
    cmake $cmakeFlags -DAVIDEMUX_INSTALL_PREFIX=$out \
      -DAVIDEMUX_SOURCE_DIR=$NIX_BUILD_TOP/$sourceRoot \
      -DAVIDEMUX_CORECONFIG_DIR=$NIX_BUILD_TOP/$sourceRoot/build/config ../plugins

    make
    make install
  '';

  meta = { 
    homepage = http://fixounet.free.fr/avidemux/;
    description = "Free video editor designed for simple video editing tasks";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
