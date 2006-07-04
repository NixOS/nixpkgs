{stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, glib, pango, atk, freetype, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl, perlXMLParser, python, pygtk}:

stdenv.mkDerivation {
  name = "gimp-2.3.9";
  src = fetchurl {
    url = ftp://ftp.gimp.org/pub/gimp/v2.3/gimp-2.3.9.tar.bz2;
    md5 = "4299e81e1824e08a90b50dc8beb46151" ;
  };
  
  buildInputs = [ pkgconfig gtk libgtkhtml glib pango atk freetype fontconfig libart_lgpl libtiff libjpeg libpng libexif zlib perl perlXMLParser python pygtk] ;

  configureFlags = [ "--disable-print" ];
}
