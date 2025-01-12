{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libjack2,
  ladspaH,
  gtk2,
  alsa-lib,
  libxml2,
  lrdf,
}:
stdenv.mkDerivation rec {
  pname = "jack-rack";
  version = "1.4.7";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1lmibx9gicagcpcisacj6qhq6i08lkl5x8szysjqvbgpxl9qg045";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libjack2
    ladspaH
    gtk2
    alsa-lib
    libxml2
    lrdf
  ];
  NIX_LDFLAGS = "-lm -lpthread";

  meta = {
    description = ''An effects "rack" for the JACK low latency audio API'';
    longDescription = ''
      JACK Rack is an effects "rack" for the JACK low latency audio
      API. The rack can be filled with LADSPA effects plugins and can
      be controlled using the ALSA sequencer. It's phat; it turns your
      computer into an effects box.
    '';
    homepage = "https://jack-rack.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.astsmtl ];
    platforms = lib.platforms.linux;
  };
}
