{stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, freetype
, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl
, perlXMLParser, python, pygtk, gettext}:

stdenv.mkDerivation {
  name = "gimp-2.3.16";
  src = fetchurl {
    url = ftp://ftp.gimp.org/pub/gimp/v2.3/gimp-2.3.16.tar.bz2;
    sha256 = "1x4n9zddvw2krb2vs5rbar488b1vy7jq8jlb82nj92l6kz9sxk7x" ;
  };
  
  buildInputs = [ pkgconfig gtk libgtkhtml freetype fontconfig
                  libart_lgpl libtiff libjpeg libpng libexif zlib perl
                   perlXMLParser python pygtk gettext ] ;

  configureFlags = [ "--disable-print" ];
}
