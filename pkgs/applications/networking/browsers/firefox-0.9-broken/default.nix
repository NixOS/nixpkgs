{ stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL
}:

assert pkgconfig != null && gtk != null && perl != null
  && zip != null && libIDL != null;

# !!! assert libIDL.glib == gtk.glib;

stdenv.mkDerivation {
  name = "firefox-0.9";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/0.9/firefox-0.9-source.tar.bz2;
    md5 = "1dda543d1245db09cea9ad7b9a44146c";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL];
}
