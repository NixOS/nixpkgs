{ stdenv, fetchgit, autoconf, automake, pkgconfig, libtool, intltool, libxslt
, babl, gegl, gtk, glib, gexiv2, gdk_pixbuf, pango, cairo, freetype
, fontconfig, lcms, libpng, libjpeg, poppler, libtiff, webkit, libmng, librsvg
, libwmf, zlib, libzip, ghostscript, aalib, jasper, python, pygtk, libart_lgpl
, libexif, gettext, xlibs, wrapPython, openexr }:

stdenv.mkDerivation rec {
  rev = "4dab80b9efb9280eed029807a73c569159c4dac7";
  name = "gimp-${rev}";

  src = fetchgit {
    inherit rev;
    url = "git://git.gnome.org/gimp";
    sha256 = "0llff710fbbpxwb4g1yp7pq2v6wqfdriilmsk930gh7cpa6mg33f";
  };

  buildInputs =
    [ autoconf automake pkgconfig libtool intltool libxslt babl gegl gtk glib
      gexiv2 gdk_pixbuf pango cairo freetype fontconfig lcms libpng libjpeg
      poppler libtiff webkit libmng librsvg libwmf zlib libzip ghostscript
      aalib jasper python pygtk libart_lgpl libexif gettext xlibs.libXpm
      wrapPython openexr
    ];

  preConfigure = "./autogen.sh --disable-gtk-doc";

  pythonPath = [ pygtk ];

  postInstall = ''wrapPythonPrograms'';

  # probably its a good idea to use the same gtk in plugins ?
  passthru = { inherit gtk; };

  # "screenshot" needs this.
  NIX_LDFLAGS = "-rpath ${xlibs.libX11}/lib";

  meta = {
    description = "The GNU Image Manipulation Program";
    homepage = http://www.gimp.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
    maintainers = [ stdenv.lib.maintainers.flosse ];
  };
}
