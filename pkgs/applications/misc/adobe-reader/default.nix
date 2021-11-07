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

assert stdenv.hostPlatform.system == "i686-linux";

let
  baseVersion = "9.5.5";
in
stdenv.mkDerivation rec {
  pname = "adobe-reader";
  version = "${baseVersion}-1";

  builder = ./builder.sh;

  src = fetchurl {
    url = "http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/${baseVersion}/enu/AdbeRdr${version}_i486linux_enu.tar.bz2";
    sha256 = "0h35misxrqkl5zlmmvray1bqf4ywczkm89n9qw7d9arqbg3aj3pf";
  };

  # !!! Adobe Reader contains copies of OpenSSL, libcurl, and libicu.
  # We should probably remove those and use the regular Nixpkgs
  # versions.

  libPath = lib.makeLibraryPath
    [ stdenv.cc.cc libX11 zlib libxml2 cups pango atk gtk2 glib gdk-pixbuf gdk-pixbuf-xlib ];

  passthru.mozillaPlugin = "/libexec/adobe-reader/Browser/intellinux";

  meta = {
    description = "Adobe Reader, a viewer for PDF documents";
    homepage = "http://www.adobe.com/products/reader";
    license = lib.licenses.unfree;
    knownVulnerabilities = [
      "Numerous unresolved vulnerabilities"
      "See: https://www.cvedetails.com/product/497/Adobe-Acrobat-Reader.html?vendor_id=53"
    ];
  };
}
