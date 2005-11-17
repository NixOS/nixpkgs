{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

stdenv.mkDerivation {
  name = "firefox-1.5rc2";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/1.5rc2/source/firefox-1.5rc2-source.tar.bz2;
    md5 = "5e93802fe6f6b74bf98d9902cc5c30a3";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];
  inherit gtk;

  patches = [./writable-copies.patch];
}
