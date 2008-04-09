{ xineramaSupport ? false
, stdenv, fetchurl, libXt, libXp, libXext, libX11, libXinerama ? null
, glib, pango, atk, gtk, libstdcpp5, zlib
, fastStart ? false
}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "acrobat-reader-7.0.9";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://ardownload.adobe.com/pub/adobe/reader/unix/7x/7.0.9/enu/AdobeReader_enu-7.0.9-1.i386.tar.gz;
    sha256 = "0qs8v57gamkk243f44yqxic93izf0bn2d9l4wwbqqy1jv5s125hy";
  };
  
  libPath = [
    libXt libXp libXext libX11 glib pango atk gtk libstdcpp5 zlib
    (if xineramaSupport then libXinerama else null)
  ];
  
  inherit fastStart;
  
  meta = {
    description = "Adobe Reader, a viewer for PDF documents";
    homepage = http://www.adobe.com/products/reader;
  };
}
