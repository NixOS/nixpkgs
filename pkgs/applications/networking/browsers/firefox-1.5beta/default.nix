{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

stdenv.mkDerivation {
  name = "firefox-1.5beta2";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/1.5b2/source/firefox-1.5b2-source.tar.bz2;
    md5 = "08eb51cbab8050ebfd3d53e6592fc0f0";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];
  inherit gtk;

  patches = [./writable-copies.patch];
}
