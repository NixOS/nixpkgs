{stdenv, fetchurl, pkgconfig, firefox, libXpm}:

# Note: we shouldn't be dependent on Firefox.  The only thing we need
# are the include files so that we can access the plugin API (I
# think).

(stdenv.mkDerivation {
  name = "mplayerplug-in-2.80";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/mplayerplug-in/mplayerplug-in-2.80.tar.gz;
    md5 = "ce3235ff7d46fae416cfb175193a5f25";
  };

  buildInputs = [pkgconfig firefox (firefox.gtk) libXpm];
  
  inherit firefox;
}) // {mozillaPlugin = "/lib/mozilla/plugins";}
