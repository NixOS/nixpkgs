{ stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, freetype
, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl
, perlXMLParser, python, pygtk, gettext, xlibs, intltool, babl, gegl
}:

stdenv.mkDerivation {
  name = "gimp-2.6.1";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gimp/v2.6/gimp-2.6.1.tar.bz2;
    sha256 = "02lacx01marjc4kkpr4m2c1z1rj1sv6rg4wjyv06whjb5nh0qpq9";
  };
  
  buildInputs = [
    pkgconfig gtk libgtkhtml freetype fontconfig
    libart_lgpl libtiff libjpeg libpng libexif zlib perl
    perlXMLParser python pygtk gettext intltool babl gegl
  ];

  configureFlags = [ "--disable-print" ];

  # "screenshot" needs this.
  NIX_LDFLAGS = "-rpath ${xlibs.libX11}/lib";

  meta = {
    description = "The GNU Image Manipulation Program";
    homepage = http://www.gimp.org/;
    license = "GPL";
  };
}
