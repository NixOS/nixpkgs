{stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, glib, pango, atk, freetype
, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl
, perlXMLParser, python, pygtk, gettext}:

stdenv.mkDerivation {
  name = "gimp-2.3.10";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gimp-2.3.10.tar.bz2;
    md5 = "a46acb413484300583ffca1fa54e0874" ;
  };
  
  buildInputs = [ pkgconfig gtk libgtkhtml glib pango atk freetype fontconfig
                  libart_lgpl libtiff libjpeg libpng libexif zlib perl
                   perlXMLParser python pygtk gettext ] ;

  configureFlags = [ "--disable-print" ];
}
