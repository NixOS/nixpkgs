{stdenv, fetchurl, cmake, pkgconfig, libxml2, qt4, gtk, gettext, SDL,
libXv, pixman, libpthreadstubs, libXau, libXdmcp }:

stdenv.mkDerivation {
  name = "avidemux-2.5.1";
  
  src = fetchurl {
    url = mirror://sourceforge/avidemux/avidemux_2.5.1.tar.gz;
    sha256 = "14jwrblbli7bswx4i7b85l0s1msx8rxrqb908df3z8jxm6w4cm9g";
  };
  
  buildInputs = [ cmake pkgconfig libxml2 qt4 gtk gettext SDL libXv
    pixman libpthreadstubs libXau libXdmcp ];

  cmakeFlags = "-DPTHREAD_INCLUDE_DIR=${stdenv.gcc.libc}/include" +
    " -DGETTEXT_INCLUDE_DIR=${gettext}/include" +
    " -DSDL_INCLUDE_DIR=${SDL}/include/SDL" +
    " -DCMAKE_SKIP_BUILD_RPATH=ON" +
    " -DCMAKE_BUILD_TYPE=Release";

  NIX_LDFLAGS="-lxml2 -lXv -lSDL -lQtGui -lQtCore";

  meta = { 
    homepage = http://fixounet.free.fr/avidemux/;
    description = "Free video editor designed for simple video editing tasks";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
