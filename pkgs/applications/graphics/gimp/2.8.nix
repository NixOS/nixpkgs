{ stdenv, fetchurl, pkgconfig, intltool, babl, gegl, gtk, glib, gdk_pixbuf
, pango, cairo, freetype, fontconfig, lcms, libpng, libjpeg, poppler, libtiff
, webkit, libmng, librsvg, libwmf, zlib, libzip, ghostscript, aalib, jasper
, python, pygtk, libart_lgpl, libexif, gettext, xlibs }:

stdenv.mkDerivation rec {
  name = "gimp-2.8.8";

  src = fetchurl {
    url = "ftp://ftp.gimp.org/pub/gimp/v2.8/${name}.tar.bz2";
    md5 = "ef2547c3514a1096931637bd6250635a";
  };

  buildInputs =
    [ pkgconfig intltool babl gegl gtk glib gdk_pixbuf pango cairo
      freetype fontconfig lcms libpng libjpeg poppler libtiff webkit
      libmng librsvg libwmf zlib libzip ghostscript aalib jasper
      python pygtk libart_lgpl libexif gettext xlibs.libXpm
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
