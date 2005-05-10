{stdenv, fetchurl, libXt, libXp, libXext, libX11, glib, pango, atk, gtk, libstdcpp5, zlib}:

stdenv.mkDerivation {
  name = "acrobat-reader-7.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.adobe.com/pub/adobe/reader/unix/7x/7.0/enu/AdbeRdr70_linux_enu.tar.gz;
    md5 = "0ce9b4fc702f831db97a627ef2629675";
  };
  
  libPath = [libXt libXp libXext libX11 glib pango atk gtk libstdcpp5 zlib];
}
