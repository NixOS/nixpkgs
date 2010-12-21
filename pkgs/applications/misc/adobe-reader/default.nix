{ stdenv, fetchurl, libX11, cups, glib, pango, atk, gtk, zlib, libxml2 }:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "adobe-reader-9.4-1";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.4.0/enu/AdbeRdr9.4-1_i486linux_enu.tar.bz2;
    sha256 = "093msw0b5k3ab0vv7bh4n81fxp51s2lynvsm076i5jvlp71l8adf";
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
