{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

(stdenv.mkDerivation {
  name = "firefox-1.0pre-rc1";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.eunet.ie/mirrors/ftp.mozilla.org/firefox/releases/1.0rc1/firefox-1.0rc1-source.tar.bz2;
    md5 = "7a0411859fc5d5f647e211c24beaf94b";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];

  patches = [./writable-copies.patch];
}) // {inherit gtk;}