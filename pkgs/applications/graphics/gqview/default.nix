{stdenv, fetchurl, pkgconfig, gtk, libpng}:

assert pkgconfig != null && gtk != null && libpng != null;
# Note that we cannot just copy gtk's png attribute, since gtk might
# not be linked against png.
# !!! assert libpng == gtk.libpng;

stdenv.mkDerivation {
  name = "gqview-2.1.1";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gqview-2.1.1.tar.gz;
    md5 = "2cd110305cfe4c530fcd6e34bb52e1f2";
  };

  buildInputs = [pkgconfig gtk libpng];
}
