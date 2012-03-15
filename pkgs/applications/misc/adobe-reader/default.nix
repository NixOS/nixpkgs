{ stdenv, fetchurl, libX11, cups, zlib, libxml2, pango, atk, gtk, glib
, gdk_pixbuf }:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "adobe-reader-9.4.7-1";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.4.7/enu/AdbeRdr9.4.7-1_i486linux_enu.tar.bz2;
    sha256 = "0bzx1rcwc9bi5jkh8f8hjb354zxlvvx37lhm0l2r0mjxj8fimfb5";
  };

  # !!! Adobe Reader contains copies of OpenSSL, libcurl, and libicu.
  # We should probably remove those and use the regular Nixpkgs
  # versions.
  
  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.gcc.gcc libX11 zlib libxml2 cups pango atk gtk glib gdk_pixbuf ];
  
  meta = {
    description = "Adobe Reader, a viewer for PDF documents";
    homepage = http://www.adobe.com/products/reader;
    license = "unfree";
  };
}
