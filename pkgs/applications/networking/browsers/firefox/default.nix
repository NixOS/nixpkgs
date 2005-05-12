{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

(stdenv.mkDerivation {
  name = "firefox-1.0.4";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/1.0.4/source/firefox-1.0.4-source.tar.bz2;
    md5 = "0f5d0586750fde79ba98ecf3ee4425a7";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];

  patches = [./writable-copies.patch];
}) // {inherit gtk;}
