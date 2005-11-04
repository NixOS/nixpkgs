{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

stdenv.mkDerivation {
  name = "firefox-1.5rc1";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/1.5rc1/source/firefox-1.5rc1-source.tar.bz2;
    md5 = "9f45c0892871aebf638ea74c249727f0";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];
  inherit gtk;

  patches = [./writable-copies.patch];
}
