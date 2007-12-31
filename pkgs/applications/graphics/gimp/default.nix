{ stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, freetype
, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl
, perlXMLParser, python, pygtk, gettext, xlibs
}:

stdenv.mkDerivation {
  name = "gimp-2.4.3";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gimp/v2.4/gimp-2.4.3.tar.bz2;
    sha256 = "1m9gdm6wa33x1bymy3c2d006ks0acq1y8a94rc4401f6mrw8jj8b";
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
