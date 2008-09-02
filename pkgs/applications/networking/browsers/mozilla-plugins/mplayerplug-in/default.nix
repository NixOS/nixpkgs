{stdenv, fetchurl, pkgconfig, firefox, libXpm, gettext}:

# Note: we shouldn't be dependent on Firefox.  The only thing we need
# are the include files so that we can access the plugin API (I
# think).

stdenv.mkDerivation rec {
  name = "mplayerplug-in-3.55";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = "mirror://sourceforge/mplayerplug-in/${name}.tar.gz";
    sha256 = "0zkvqrzibrbljiccvz3rhbmgifxadlrfjylqpz48jnjx9kggynms";
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
