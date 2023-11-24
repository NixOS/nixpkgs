{ lib
, stdenv
, fetchurl
, ladspaH
}:

stdenv.mkDerivation rec {
  pname = "FIL-plugins";
  version = "0.3.0";

  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    hash = "sha256-HAvycSEZZfZwoVp3g7QWcwfbdyZKwWJKBuVmeWTajuk=";
  };

  buildInputs = [ ladspaH ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/lib/ladspa "$out/lib/ladspa" \
      --replace g++             "$CXX"
  '';

  preInstall = ''
    mkdir -p "$out/lib/ladspa"
  '';

  meta = {
    description = "a four-band parametric equaliser, which has the nice property of being stable even while parameters are being changed";
    longDescription = ''
      Each section has an active/bypass switch, frequency, bandwidth and gain controls.
      There is also a global bypass switch and gain control.
      The 2nd order resonant filters are implemented using a Mitra-Regalia style lattice filter.
      All switches and controls are internally smoothed, so they can be used 'live' whithout any clicks or zipper noises.
      This should make this plugin a good candidate for use in systems that allow automation of plugin control ports, such as Ardour, or for stage use.
    '';
    version = version;
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/ladspa/index.html";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
