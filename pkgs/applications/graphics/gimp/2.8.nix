{ stdenv, fetchurl, pkgconfig, intltool, babl, gegl, gtk, glib, gdk_pixbuf
, pango, cairo, freetype, fontconfig, lcms, libpng, libjpeg, poppler, libtiff
, webkit, libmng, librsvg, libwmf, zlib, libzip, ghostscript, aalib, jasper
, python, pygtk, libart_lgpl, libexif, gettext, xlibs, wrapPython }:

stdenv.mkDerivation rec {
  name = "gimp-2.8.10";

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v2.8/${name}.tar.bz2";
    sha256 = "1rha8yx0pplfjziqczjrxxp16vsvpmb5ziq3c218s4w9z4cqpzg7";
  };

  buildInputs =
    [ pkgconfig intltool babl gegl gtk glib gdk_pixbuf pango cairo
      freetype fontconfig lcms libpng libjpeg poppler libtiff webkit
      libmng librsvg libwmf zlib libzip ghostscript aalib jasper
      python pygtk libart_lgpl libexif gettext xlibs.libXpm
      wrapPython
    ];

  pythonPath = [ pygtk ];

  postInstall = ''wrapPythonPrograms'';

  passthru = { inherit gtk; }; # probably its a good idea to use the same gtk in plugins ?

  #configureFlags = [ "--disable-print" ];

  # "screenshot" needs this.
  NIX_LDFLAGS = "-rpath ${xlibs.libX11}/lib";

  meta = {
    description = "The GNU Image Manipulation Program";
    homepage = http://www.gimp.org/;
    license = "GPL";
    platforms = stdenv.lib.platforms.linux;
  };
}
