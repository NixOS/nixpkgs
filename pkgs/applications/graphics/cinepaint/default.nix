{ stdenv, fetchcvs, cmake, pkgconfig, gtk, freetype, fontconfig, lcms, fltk,
  flex, libtiff, libjpeg, libpng, libexif, zlib, perl, libX11,
  perlXMLParser, python, pygtk, gettext, intltool, babl, gegl,
  glib, makedepend, xf86vidmodeproto, xineramaproto, libXmu, openexr,
  mesa, libXext, libXpm, libXxf86vm, automake, autoconf, libtool } :

stdenv.mkDerivation {
  name = "cinepaint-0.25.0";

  # The developer told me this cvs fetch is 0.25.0
  src = fetchcvs {
    cvsRoot = ":pserver:anonymous@cinepaint.cvs.sourceforge.net:/cvsroot/cinepaint";
    module = "cinepaint-project";
    date = "2004-03-01";
    sha256 = "b0abefc16b4db4256e9e8dcbc5d2eff93fa3f425b8ad3a4e53345efee9f1a9dd";
  };

  buildInputs = [ cmake pkgconfig gtk freetype fontconfig lcms fltk flex libtiff
    libjpeg libpng libexif zlib perl libX11 perlXMLParser python pygtk gettext
    intltool babl gegl glib makedepend xf86vidmodeproto xineramaproto libXmu
    openexr mesa libXext libXpm libXxf86vm automake autoconf libtool ];

  dontUseCmakeConfigure = 1;

  NIX_CFLAGS_COMPILE = "-I.";

  configurePhase = ''
    cd cinepaint
    chmod 0777 autogen.sh
    ./autogen.sh
    ./configure --prefix=$out
  '';

  meta = {
    homepage = http://www.cinepaint.org/;
    license = "free";
    description = "Image editor which supports images over 8bpp and ICC profiles";
  };
}
