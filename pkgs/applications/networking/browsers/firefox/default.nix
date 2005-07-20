{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

(stdenv.mkDerivation {
  name = "firefox-1.0.6";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/1.0.6/source/firefox-1.0.6-source.tar.bz2;
    md5 = "7b4c1d10d478dcb4c52fbbe3e41745d9";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];

  patches = [./writable-copies.patch];
}) // {inherit gtk;}
