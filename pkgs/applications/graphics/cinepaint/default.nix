{ stdenv, fetchurl, cmake, pkgconfig, gtk, freetype, fontconfig, lcms,
  flex, libtiff, libjpeg, libpng, libexif, zlib, perl, libX11,
  perlXMLParser, python, pygtk, gettext, intltool, babl, gegl,
  glib, makedepend, xf86vidmodeproto, xineramaproto, libXmu, openexr,
  mesa, libXext, libXpm, libXxf86vm, pixman, libpthreadstubs } :

stdenv.mkDerivation rec {
  name = "cinepaint-1.0";

  src = fetchurl {
    url = "mirror://sourceforge/cinepaint/${name}.tgz";
    sha256 = "02mbpsykd7sfr9h6c6gxld6i3bdwnsgvm70b5yff01gwi69w2wi7";
  };

  buildInputs = [ gtk freetype fontconfig lcms flex libtiff libjpeg libpng
    libexif zlib perl libX11 perlXMLParser python pygtk gettext intltool babl
    gegl glib makedepend xf86vidmodeproto xineramaproto libXmu openexr mesa
    libXext libXpm libXxf86vm pixman libpthreadstubs
  ];

  buildNativeInputs = [ cmake pkgconfig ];

  NIX_CFLAGS_COMPILE = "-I.";

  meta = {
    homepage = http://www.cinepaint.org/;
    license = "free";
    description = "Image editor which supports images over 8bpp and ICC profiles";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.linux;
  };
}
