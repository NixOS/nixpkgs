{stdenv, fetchurl, pkgconfig, firefox, libXpm}:

# Note: we shouldn't be dependent on Firefox.  The only thing we need
# are the include files so that we can access the plugin API (I
# think).

(stdenv.mkDerivation {
  name = "mplayerplug-in-3.31";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/mplayerplug-in/mplayerplug-in-3.31.tar.gz;
    md5 = "be26b17cde385c7a34fc634d2c88c5c9";
  };

  buildInputs = [pkgconfig firefox (firefox.gtk) libXpm];
  
  inherit firefox;
}) // {mozillaPlugin = "/lib/mozilla/plugins";}
