{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

(stdenv.mkDerivation {
  name = "firefox-1.0pre-rc2";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.eunet.ie/mirrors/ftp.mozilla.org/firefox/releases/1.0rc2/source/firefox-1.0rc2-source.tar.bz2;
    md5 = "aab6ffe0e57de39b20d1c8ccef057171";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];

  patches = [./writable-copies.patch];
}) // {inherit gtk;}