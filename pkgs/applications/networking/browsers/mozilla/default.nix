{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

# !!! assert libIDL.glib == gtk.glib;

stdenv.mkDerivation {
  name = "mozilla-1.7.12";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/mozilla-1.7.12-source.tar.bz2;
    md5 = "f1ad6adbbc0510eb76d352c94c801fac";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];
  inherit gtk;

  #patches = [./writable-copies.patch];
}
