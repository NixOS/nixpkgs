{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

stdenv.mkDerivation {
  name = "firefox-1.0pre-PR-0.10.1";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.eunet.ie/mirrors/ftp.mozilla.org/firefox/releases/0.10.1/firefox-1.0PR-source.tar.bz2;
    md5 = "ff9eae3b90b8573bf44293ea44bf3c50";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];
}
