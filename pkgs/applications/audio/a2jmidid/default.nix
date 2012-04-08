{ stdenv, fetchurl, alsaLib, dbus, jackaudio, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "a2jmidid-${version}";
  version = "7";

  src = fetchurl {
    url = "http://download.gna.org/a2jmidid/${name}.tar.bz2";
    sha256 = "1pl91y7npirhmikzlizpbyx2vkfvdkvc6qvc2lv4capj3cp6ypx7";
  };

  buildInputs = [ alsaLib dbus jackaudio pkgconfig python ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    homepage = http://home.gna.org/a2jmidid;
    description = "daemon for exposing legacy ALSA sequencer applications in JACK MIDI system";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];

  };
}
