{stdenv, fetchurl, autoconf, automake, gettext, libtool, cvs, wxGTK, gtk, pkgconfig, libxml2, zip, libpng, libjpeg}:

stdenv.mkDerivation {
  name = "xaralx-0.5r1405";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://downloads2.xara.com/opensource/XaraLX-0.5r1405.tar.bz2;
    md5 = "1b087819e4b10b21da8c267ed56a45a4";
  };
  
  buildInputs = [automake autoconf gettext libtool cvs wxGTK gtk pkgconfig libxml2 zip libpng libjpeg];
  configureFlags = "--with-wx-config --disable-svnversion --disable-international";
}
