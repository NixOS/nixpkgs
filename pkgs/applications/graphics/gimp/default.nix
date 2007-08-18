{stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, freetype
, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl
, perlXMLParser, python, pygtk, gettext}:

stdenv.mkDerivation {
  name = "gimp-2.4.0-rc1";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gimp/v2.4/testing/gimp-2.4.0-rc1.tar.bz2;
    sha256 = "0n9gfmmxjjhi4dpdfwc37z8n4zsyx6byil1ig27agjgic22bydm1" ;
  };
  
  buildInputs = [ pkgconfig gtk libgtkhtml freetype fontconfig
                  libart_lgpl libtiff libjpeg libpng libexif zlib perl
                   perlXMLParser python pygtk gettext ] ;

  configureFlags = [ "--disable-print" ];
}
