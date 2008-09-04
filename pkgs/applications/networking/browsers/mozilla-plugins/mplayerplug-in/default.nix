{stdenv, fetchurl, pkgconfig, firefox, libXpm, gettext}:

stdenv.mkDerivation rec {
  name = "mplayerplug-in-3.55";

  src = fetchurl {
    url = "mirror://sourceforge/mplayerplug-in/${name}.tar.gz";
    sha256 = "0zkvqrzibrbljiccvz3rhbmgifxadlrfjylqpz48jnjx9kggynms";
  };

  buildInputs = [pkgconfig firefox (firefox.gtk) libXpm gettext];
  
  installPhase = ''
    ensureDir $out/lib/mozilla/plugins
    cp -p mplayerplug-in*.so mplayerplug-in*.xpt $out/lib/mozilla/plugins
  '';

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  meta = {
    description = "A browser plugin that uses mplayer to play digital media from websites";
    homepage = http://mplayerplug-in.sourceforge.net/;
  };
}
