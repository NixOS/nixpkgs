{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

stdenv.mkDerivation {
  name = "firefox-1.5";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/firefox-1.5-source.tar.bz2;
    md5 = "fa915ddcadecda30ed3e13694f26a779";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];
  inherit gtk;

  patches = [./writable-copies.patch];
}
