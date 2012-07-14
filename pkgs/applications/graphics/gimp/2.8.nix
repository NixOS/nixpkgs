{ stdenv, fetchurl, pkgconfig, intltool, babl, gegl, gtk, glib, gdk_pixbuf
, pango, cairo, freetype, fontconfig, lcms2, libpng, libjpeg, poppler, libtiff
, webkit, libmng, librsvg, libwmf, zlib, libzip, ghostscript, aalib, jasper
, python, pygtk, libart_lgpl, libexif, gettext, xlibs }:

stdenv.mkDerivation rec {
  name = "gimp-2.8.0";
  
  src = fetchurl {
    url = "ftp://ftp.gimp.org/pub/gimp/v2.8/${name}.tar.bz2";
    md5 = "28997d14055f15db063eb92e1c8a7ebb";
  };
  
  buildInputs = 
    [ pkgconfig intltool babl gegl gtk glib gdk_pixbuf pango cairo
      freetype fontconfig lcms2 libpng libjpeg poppler libtiff webkit
      libmng librsvg libwmf zlib libzip ghostscript aalib jasper
      python pygtk libart_lgpl libexif gettext 
    ];

  passthru = { inherit gtk; }; # probably its a good idea to use the same gtk in plugins ?

  #configureFlags = [ "--disable-print" ];

  # "screenshot" needs this.
  NIX_LDFLAGS = "-rpath ${xlibs.libX11}/lib";

  meta = {
    description = "The GNU Image Manipulation Program";
    homepage = http://www.gimp.org/;
    license = "GPL";
  };
}
