{ stdenv, fetchurl, cmake, pkgconfig, gtk, freetype, fontconfig, lcms,
  flex, libtiff, libjpeg, libpng, libexif, zlib, perl, libX11,
  perlXMLParser, python, pygtk, gettext, intltool, babl, gegl,
  glib, makedepend, xf86vidmodeproto, xineramaproto, libXmu, openexr,
  mesa, libXext, libXpm, libXau, libXxf86vm, pixman, libpthreadstubs, fltk } :

stdenv.mkDerivation rec {
  name = "cinepaint-1.1";

  src = fetchurl {
    url = "mirror://sourceforge/cinepaint/${name}.tgz";
    sha256 = "0b5g4bkq62yiz1cnb2vfij0a8fw5w5z202v5dm4dh89k7cj0yq4w";
  };

  buildInputs = [ libpng gtk freetype fontconfig lcms flex libtiff libjpeg
    libexif zlib perl libX11 perlXMLParser python pygtk gettext intltool babl
    gegl glib makedepend xf86vidmodeproto xineramaproto libXmu openexr mesa
    libXext libXpm libXau libXxf86vm pixman libpthreadstubs fltk
  ];

  hardeningDisable = [ "format" ];

  patches = [ ./install.patch ];

  nativeBuildInputs = [ cmake pkgconfig ];

  NIX_LDFLAGS = "-llcms -ljpeg -lX11";

  meta = {
    homepage = http://www.cinepaint.org/;
    license = stdenv.lib.licenses.free;
    description = "Image editor which supports images over 8bpp and ICC profiles";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.linux;
  };
}
