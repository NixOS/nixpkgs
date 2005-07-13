{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

(stdenv.mkDerivation {
  name = "firefox-1.0.5";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/1.0.5/source/firefox-1.0.5-source.tar.bz2;
    md5 = "b50fe116305b7f56b2105d464110228d";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];

  patches = [./writable-copies.patch];
}) // {inherit gtk;}
