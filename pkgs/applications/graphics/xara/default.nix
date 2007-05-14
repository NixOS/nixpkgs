{stdenv, fetchurl, autoconf, automake, gettext, libtool, cvs, wxGTK, gtk,
pkgconfig, libxml2, zip, libpng, libjpeg}:

stdenv.mkDerivation {
  name = "xaralx-0.7r1766";
  src = fetchurl {
    url = http://downloads2.xara.com/opensource/XaraLX-0.7r1766.tar.bz2;
    sha256 = "1rcl7hqvcai586jky7hvzxhnq8q0ka2rsmgiq5ijwclgr5d4ah7n";
  };
  
  buildInputs = [automake autoconf gettext libtool cvs wxGTK gtk pkgconfig libxml2 zip libpng libjpeg];
  configureFlags = "--with-wx-config --disable-svnversion --disable-international";
}
