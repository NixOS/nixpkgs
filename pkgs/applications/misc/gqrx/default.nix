{ stdenv, fetchFromGitHub, cmake, qtbase, qtsvg, gnuradio, boost, gnuradio-osmosdr
# drivers (optional):
, rtl-sdr, hackrf
, pulseaudioSupport ? true, libpulseaudio
}:

assert pulseaudioSupport -> libpulseaudio != null;

stdenv.mkDerivation rec {
  name = "gqrx-${version}";
  version = "2.11.4";

  src = fetchFromGitHub {
    owner = "csete";
    repo = "gqrx";
    rev = "v${version}";
    sha256 = "0a5w9b3fi4f95j34cqsbzxks0d9hmrz4cznc8pi9b0pwvx13hqhm";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    qtbase qtsvg gnuradio boost gnuradio-osmosdr rtl-sdr hackrf
  ] ++ stdenv.lib.optionals pulseaudioSupport [ libpulseaudio ];

  enableParallelBuilding = true;

  postInstall = ''
    install -vD $src/gqrx.desktop -t "$out/share/applications/"
    install -vD $src/resources/icons/gqrx.svg -t "$out/share/icons/"
  '';

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
    platforms = platforms.linux;  # should work on Darwin / macOS too
    maintainers = with maintainers; [ bjornfor the-kenny fpletz ];
  };
}
