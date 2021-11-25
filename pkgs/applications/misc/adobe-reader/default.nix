{ lib
, stdenv
, fetchurl
, libX11
, cups
, zlib
, libxml2
, pango
, atk
, gtk2
, glib
, gdk-pixbuf
, gdk-pixbuf-xlib
}:

stdenv.mkDerivation rec {
  pname = "adobe-reader";
  version = "9.5.5";

  # TODO: convert to phases
  builder = ./builder.sh;

  src = fetchurl {
    url = "http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/${version}/enu/AdbeRdr${version}-1_i486linux_enu.tar.bz2";
    sha256 = "0h35misxrqkl5zlmmvray1bqf4ywczkm89n9qw7d9arqbg3aj3pf";
  };

  # !!! Adobe Reader contains copies of OpenSSL, libcurl, and libicu.
  # We should probably remove those and use the regular Nixpkgs versions.
  libPath = lib.makeLibraryPath [ stdenv.cc.cc libX11 zlib libxml2 cups pango atk gtk2 glib gdk-pixbuf gdk-pixbuf-xlib ];

  passthru.mozillaPlugin = "/libexec/adobe-reader/Browser/intellinux";

  meta = {
    description = "Adobe Reader, a viewer for PDF documents";
    homepage = "http://www.adobe.com/products/reader";
    license = lib.licenses.unfree;
    knownVulnerabilities = [
      "Numerous unresolved vulnerabilities"
      "See: https://www.cvedetails.com/product/497/Adobe-Acrobat-Reader.html?vendor_id=53"
    ];
    platforms = [ "i686-linux" ];
  };
}
