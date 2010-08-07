{ stdenv, fetchurl, libX11, cups, glib, pango, atk, gtk, zlib, libxml2 }:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "adobe-reader-9.3.3-1";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.3.3/enu/AdbeRdr9.3.3-1_i486linux_enu.tar.bz2;
    sha256 = "1qssbdjy3v07agyh55bhsmvzakq9bs3hd6dw032ikwbpvb2gs807";
  };

  # !!! Adobe Reader contains copies of OpenSSL, libcurl, and libicu.
  # We should probably remove those and use the regular Nixpkgs
  # versions.
  
  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.gcc.gcc libX11 glib pango atk gtk zlib libxml2 cups ];
  
  meta = {
    description = "Adobe Reader, a viewer for PDF documents";
    homepage = http://www.adobe.com/products/reader;
  };
}
