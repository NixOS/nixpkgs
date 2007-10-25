{ stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, freetype
, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl
, perlXMLParser, python, pygtk, gettext, xlibs
}:

stdenv.mkDerivation {
  name = "gimp-2.4.0";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gimp/v2.4/gimp-2.4.0.tar.bz2;
    sha256 = "1p594r45hxk14469ma8g5j96nw5q9j6a3i0n6hbakfsh41izpsnx";
  };
  
  buildInputs = [
    pkgconfig gtk libgtkhtml freetype fontconfig
    libart_lgpl libtiff libjpeg libpng libexif zlib perl
    perlXMLParser python pygtk gettext
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
