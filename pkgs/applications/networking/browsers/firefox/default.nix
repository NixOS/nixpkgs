{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

stdenv.mkDerivation {
  name = "firefox-1.5.0.1";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://releases.mozilla.org/pub/mozilla.org/firefox/releases/1.5.0.1/source/firefox-1.5.0.1-source.tar.bz2;
    md5 = "c76f02956645bc823241379e27f76bb5";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];
  inherit gtk;

  patches = [./writable-copies.patch];
}
