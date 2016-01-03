{stdenv, fetchurl, cmake, pkgconfig, libxml2, qt4Support ? true,
gtkSupport ? false, qt4, gtk ? null, gettext, SDL,
libXv, pixman, libpthreadstubs, libXau, libXdmcp, libxslt, x264,
alsaLib, lame, faad2, libvorbis, yasm, libvpx, xvidcore, libva, sqlite,
faac ? null, faacSupport ? false }:

assert stdenv ? glibc;
assert faacSupport -> faac != null;

let 
  additional = folder: ''
    cd $NIX_BUILD_TOP/$sourceRoot
    mkdir -p build_${folder}
    cd build_${folder}
    cmake $cmakeFlags -DAVIDEMUX_INSTALL_PREFIX=$out \
      -DAVIDEMUX_SOURCE_DIR=$NIX_BUILD_TOP/$sourceRoot \
      -DAVIDEMUX_CORECONFIG_DIR=$NIX_BUILD_TOP/$sourceRoot/build/config $NIX_BUILD_TOP/$sourceRoot/${folder} 
    make
    cmake -P cmake_install.cmake
  '';
in

stdenv.mkDerivation {
  name = "avidemux-2.5.6";

  src = fetchurl {
    url = mirror://sourceforge/avidemux/avidemux_2.5.6.tar.gz;
    sha256 = "12wvxz0n2g85f079d8mdkkp2zm279d34m9v7qgcqndh48cn7znnn";
  };

  buildInputs = [ cmake pkgconfig libxml2 qt4 gtk gettext SDL libXv
    pixman libpthreadstubs libXau libXdmcp libxslt x264 alsaLib
    lame faad2 libvorbis yasm libvpx xvidcore libva sqlite
  ] ++ stdenv.lib.optional faacSupport faac
  ++ stdenv.lib.optional gtkSupport gtk
  ++ stdenv.lib.optional qt4Support qt4;

  preConfigure = "cd $NIX_BUILD_TOP/$sourceRoot/avidemux_core";

  cmakeFlags = "-DPTHREAD_INCLUDE_DIR=${stdenv.glibc}/include" +
    " -DGETTEXT_INCLUDE_DIR=${gettext}/include" +
    " -DPLUGIN_UI=${if (gtkSupport && qt4Support) then "ALL" else (if gtkSupport then "GTK" else (if qt4Support then "QT4" else "COMMON"))}" + 
    " -DSDL_INCLUDE_DIR=${SDL}/include/SDL";

  NIX_LDFLAGS="-lpthread";

  postInstall = '' 
    ${additional "avidemux_plugins"}
    ${stdenv.lib.optionalString gtkSupport (additional "avidemux/gtk")}
    ${stdenv.lib.optionalString qt4Support (additional "avidemux/qt4")}
  '';


  meta = {
    homepage = http://fixounet.free.fr/avidemux/;
    description = "Free video editor designed for simple video editing tasks";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
