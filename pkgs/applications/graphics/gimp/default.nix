{stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, glib, pango, atk, freetype, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl, perlXMLParser, python, pygtk}:

stdenv.mkDerivation {
  name = "gimp-2.3.6";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gimp-2.3.6.tar.bz2;
    md5 = "ce8ad77f4eb47abb868e6b4eb1f97943" ;
  };
  
  buildInputs = [ pkgconfig gtk libgtkhtml glib pango atk freetype fontconfig libart_lgpl libtiff libjpeg libpng libexif zlib perl perlXMLParser python pygtk] ;

  configureFlags = [ "--disable-print" ];
}
