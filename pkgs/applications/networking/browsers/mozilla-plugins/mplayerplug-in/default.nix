{stdenv, fetchurl, pkgconfig, firefox, libXpm}:

# Note: we shouldn't be dependent on Firefox.  The only thing we need
# are the include files so that we can access the plugin API (I
# think).

stdenv.mkDerivation {
  name = "mplayerplug-in-2.70";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/mplayerplug-in-2.70.tar.gz;
    md5 = "90784c7ccb40037b446053f0c1d1c2b4";
  };

  buildInputs = [pkgconfig firefox (firefox.gtk) libXpm];
  
  inherit firefox;
}
