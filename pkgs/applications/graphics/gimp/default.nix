{stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, glib, pango, atk, freetype, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl, perlXMLParser}:

stdenv.mkDerivation {
  name = "gimp-2.3.0";
  src = fetchurl {
    url = http://gnu.kookel.org/ftp/gimp/v2.3/gimp-2.3.0.tar.bz2;
    md5 = "88e536ba0e4882958eb98bc0eadc8dd4" ;
  };
  
  buildInputs = [ pkgconfig gtk libgtkhtml glib pango atk freetype fontconfig libart_lgpl libtiff libjpeg libpng libexif zlib perl perlXMLParser ] ;

  configureFlags = [ "--disable-print" ];
}
