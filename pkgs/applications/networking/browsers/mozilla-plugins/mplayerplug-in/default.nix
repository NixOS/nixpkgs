{stdenv, fetchurl, pkgconfig, firefox, libXpm, gettext}:

# Note: we shouldn't be dependent on Firefox.  The only thing we need
# are the include files so that we can access the plugin API (I
# think).

stdenv.mkDerivation {
  name = "mplayerplug-in-3.50";

  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/mplayerplug-in/mplayerplug-in-3.50.tar.gz;
    sha256 = "00jcbwl3wa6s4784c3wrz718f6jj1zkdfjbp7d2nhiafxrjqwsq4";
  };

  buildInputs = [pkgconfig firefox (firefox.gtk) libXpm gettext];
  
  inherit firefox;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  meta = {
    description = "A browser plugin that uses mplayer to play digital media from websites";
    homepage = http://mplayerplug-in.sourceforge.net/;
  };
}
