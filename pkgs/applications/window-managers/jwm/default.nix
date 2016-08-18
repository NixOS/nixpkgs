{ stdenv, fetchurl, pkgconfig, automake, autoconf, libtool, gettext, which,
  xorg, libX11, libXext, libXinerama, libXpm, libXft, libXau, libXdmcp,
  libXmu, libpng, libjpeg, expat, xproto, xextproto, xineramaproto, librsvg,
  freetype, fontconfig }:

stdenv.mkDerivation rec {
  name = "jwm-${version}";
  version = "1548";
  
  src = fetchurl {
     url = "https://github.com/joewing/jwm/archive/s${version}.tar.gz";
     sha256 = "1ih5y7567vwcbnkjwm3cc9iq4n9rzz818mkh6ryli9ld230hla5r";
  };

  nativeBuildInputs = [ pkgconfig automake autoconf libtool gettext which ];

  buildInputs = [ libX11 libXext libXinerama libXpm libXft xorg.libXrender
    libXau libXdmcp libXmu libpng libjpeg expat xproto xextproto xineramaproto
    librsvg freetype fontconfig ];

  enableParallelBuilding = true;

  preConfigure = "./autogen.sh";

  meta = {
    homepage = "http://joewing.net/projects/jwm/";
    description = "Joe's Window Manager is a light-weight X11 window manager";
    license = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
