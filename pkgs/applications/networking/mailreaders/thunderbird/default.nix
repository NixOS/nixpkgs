{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL}:

assert pkgconfig != null && gtk != null && perl != null
  && zip != null && libIDL != null;

# !!! assert libIDL.glib == gtk.glib;

stdenv.mkDerivation {
  name = "thunderbird-0.8";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/thunderbird-source-0.8.tar.bz2;
    md5 = "76de1827d66ac482cfc4dd32e7b1e257";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL];
}
