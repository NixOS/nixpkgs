{ stdenv, fetchurl, libX11, cups, gtkLibs, zlib, libxml2 }:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "adobe-reader-9.4.2-1";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.4.2/enu/AdbeRdr9.4.2-1_i486linux_enu.tar.bz2;
    sha256 = "0xm8ngr7lslhxli9ly1g2w7ichip88vpf7lfx1ma0liaw4m2gv0h";
  };

  # !!! Adobe Reader contains copies of OpenSSL, libcurl, and libicu.
  # We should probably remove those and use the regular Nixpkgs
  # versions.
  
  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.gcc.gcc libX11 zlib libxml2 cups 
      gtkLibs.pango
      gtkLibs.atk
      gtkLibs.gtk
      gtkLibs.glib
      gtkLibs.gdk_pixbuf
    ];
  
  meta = {
    description = "Adobe Reader, a viewer for PDF documents";
    homepage = http://www.adobe.com/products/reader;
    license = "unfree";
  };
}
