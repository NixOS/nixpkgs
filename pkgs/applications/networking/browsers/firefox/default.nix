{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

(stdenv.mkDerivation {
  name = "firefox-1.0";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.eunet.ie/mirrors/ftp.mozilla.org/firefox/releases/1.0/source/firefox-1.0-source.tar.bz2;
    md5 = "49c16a71f4de014ea471be81e46b1da8";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];

  patches = [./writable-copies.patch];
}) // {inherit gtk;}