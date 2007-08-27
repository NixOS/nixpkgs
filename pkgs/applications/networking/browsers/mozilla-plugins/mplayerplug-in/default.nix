{stdenv, fetchurl, pkgconfig, firefox, libXpm, gettext}:

# Note: we shouldn't be dependent on Firefox.  The only thing we need
# are the include files so that we can access the plugin API (I
# think).

(stdenv.mkDerivation {
  name = "mplayerplug-in-3.35";

  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/mplayerplug-in/mplayerplug-in-3.35.tar.gz;
    sha256 = "0zxd2nnmj4n9rkndd614ljv7ylz4f4jqvx1wswqfw5j7hwxm34dw";
  };

  buildInputs = [pkgconfig firefox (firefox.gtk) libXpm gettext];
  
  inherit firefox;
}) // {mozillaPlugin = "/lib/mozilla/plugins";}
