{ stdenv, fetchurl, pkgconfig, gtk, freetype, fontconfig, lcms, fltk,
  flex, libtiff, libjpeg, libpng, libexif, zlib, perl, libX11,
  perlXMLParser, python, pygtk, gettext, intltool, babl, gegl,
  glib, makedepend, xf86vidmodeproto, xineramaproto, libXmu, openexr,
  mesa, libXext, libXpm, libXxf86vm } :

stdenv.mkDerivation {
  name = "cinepaint-0.22-1";

  src = fetchurl {
    url = mirror://sourceforge/cinepaint/cinepaint-0.22-1.tar.gz;
    sha256 = "bb08a9210658959772df12408769d660999ede168b7431514e1f3cead07c0fea";
  };

  buildInputs = [ pkgconfig gtk freetype fontconfig lcms fltk flex libtiff
    libjpeg libpng libexif zlib perl libX11 perlXMLParser python pygtk gettext
    intltool babl gegl glib makedepend xf86vidmodeproto xineramaproto libXmu
    openexr mesa libXext libXpm libXxf86vm ];

  patches = [ ./fltk.patch ];

  prePatch = ''
    sed -i -e s@/usr/X11R6/bin/makedepend@${makedepend}/bin/makedepend@ \
      -e s@/usr/X11R6/include/X11/extensions/xf86vmode@${xf86vidmodeproto}/include/X11/extensions/xf86vmode@ \
      -e s@/usr/X11R6/include/X11/Xlib.h@${libX11}/include/X11/Xlib.h@ \
      -e s@/usr/X11R6/include/X11/extensions/Xinerama.h@${xineramaproto}/include/X11/extensions/Xinerama.h@ \
      -e s@/usr/X11R6/lib/libfreetype.a@${freetype}/lib/libfreetype.a@ \
      plug-ins/icc_examin/icc_examin/configure \
      plug-ins/icc_examin/icc_examin/configure.sh
  '';

  configureFlags = [ "--disable-print" "--enable-gtk2" ];

  meta = {
    homepage = http://www.cinepaint.org/;
    license = "free";
    description = "Image editor which supports images over 8bpp and ICC profiles";
  };
}
