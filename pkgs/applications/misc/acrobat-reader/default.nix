{stdenv, fetchurl, libXt, libXp, libXext, libX11, glib, pango, atk, gtk, libstdcpp5, zlib}:

stdenv.mkDerivation {
  name = "acrobat-reader-7.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.adobe.com/pub/adobe/reader/unix/7x/7.0/enu/AdbeRdr70_linux_enu.tar.gz;
    md5 = "f847ce21e5d871837f2dc1d2f1baf9a9";
  };
  
  libPath = [libXt libXp libXext libX11 glib pango atk gtk libstdcpp5 zlib];
}
