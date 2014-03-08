{ stdenv, fetchurl, qt4, gnuradio, boost, gnuradio-osmosdr
# drivers (optional):
, rtl-sdr
, pulseaudioSupport ? true, pulseaudio
}:

assert pulseaudioSupport -> pulseaudio != null;

stdenv.mkDerivation rec {
  name = "gqrx-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/gqrx/${version}/${name}-src.tar.gz";
    sha256 = "15ncx2shh43skph7sj3jvmkls9cbbbysld49c8xd23fhdsxanj9x";
  };

  buildInputs = [
    qt4 gnuradio boost gnuradio-osmosdr rtl-sdr
  ] ++ stdenv.lib.optionals pulseaudioSupport [ pulseaudio ];

  configurePhase = ''qmake PREFIX="$out"'';

  meta = with stdenv.lib; {
    description = "Software defined radio (SDR) receiver";
    longDescription = ''
      Gqrx is a software defined radio receiver powered by GNU Radio and the Qt
      GUI toolkit. It can process I/Q data from many types of input devices,
      including Funcube Dongle Pro/Pro+, rtl-sdr, HackRF, and Universal
      Software Radio Peripheral (USRP) devices.
    '';
    homepage = http://gqrx.dk/;
    # Some of the code comes from the Cutesdr project, with a BSD license, but
    # it's currently unknown which version of the BSD license that is.
    license = licenses.gpl3Plus;
    platforms = platforms.linux;  # should work on Darwin / OS X too
    maintainers = [ maintainers.bjornfor ];
  };
}
