{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

assert pkgconfig != null && gtk != null && perl != null
  && zip != null && libIDL != null;

# !!! assert libIDL.glib == gtk.glib;

stdenv.mkDerivation {
  name = "firefox-1.0pre-PR";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.artfiles.org/mozilla.org/firefox/releases/0.10/firefox-1.0PR-source.tar.bz2;
    md5 = "b81ebc5f01448313add23ed44c47cf5e";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];
}
