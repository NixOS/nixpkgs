{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

(stdenv.mkDerivation {
  name = "firefox-1.0.7";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/1.0.7/source/firefox-1.0.7-source.tar.bz2;
    md5 = "5704a8c36de84b408e069afb0c5bc1df";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];

  patches = [./writable-copies.patch];
}) // {inherit gtk;}
