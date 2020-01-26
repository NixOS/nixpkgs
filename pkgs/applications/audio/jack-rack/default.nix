{ stdenv, fetchurl, pkgconfig, libjack2, ladspaH, gtk2, alsaLib, libxml2, librdf }:
stdenv.mkDerivation rec {
  name = "jack-rack-1.4.7";
  src = fetchurl {
    url = "mirror://sourceforge/jack-rack/${name}.tar.bz2";
    sha256 = "1lmibx9gicagcpcisacj6qhq6i08lkl5x8szysjqvbgpxl9qg045";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libjack2 ladspaH gtk2 alsaLib libxml2 librdf ];
  NIX_LDFLAGS = "-ldl -lm -lpthread";

  meta = {
    description = ''An effects "rack" for the JACK low latency audio API'';
    longDescription = ''
      JACK Rack is an effects "rack" for the JACK low latency audio
      API. The rack can be filled with LADSPA effects plugins and can
      be controlled using the ALSA sequencer. It's phat; it turns your
      computer into an effects box.
    '';
    homepage = http://jack-rack.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.astsmtl ];
    platforms = stdenv.lib.platforms.linux;
  };
}
