{ stdenv, fetchurl, pkgconfig, automake, autoconf, libtool, which, xorg,
  libX11, libXext, libXinerama, libXpm, libXft, libXau, libXdmcp, libpng,
  libjpeg, expat, xproto, xextproto, xineramaproto, librsvg, gettext,
  freetype, fontconfig }:

stdenv.mkDerivation rec {
  name = "jwm-${version}";
  version = "1406";
  
  src = fetchurl {
     url = "https://github.com/joewing/jwm/archive/s${version}.tar.gz";
     sha256 = "0yk22b7cshhyfpcqnb4p59yxspx95xg9yp1kmkxi2fyw95cacab4";
  };

  nativeBuildInputs = [ pkgconfig automake autoconf libtool which ];

  buildInputs = [ libX11 libXext libXinerama libXpm libXft xorg.libXrender
    libXau libXdmcp libpng libjpeg expat xproto xextproto xineramaproto
    librsvg gettext freetype fontconfig ];

  preConfigure = "./autogen.sh";

  meta = {
    homepage = "http://joewing.net/projects/jwm/";
    description = "A window manager for X11 that requires only Xlib";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
