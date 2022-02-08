{ lib
, fetchFromGitHub
, cmake
, pkg-config
, qt5
, gnuradio3_8Minimal
, thrift
, log4cpp
, mpir
, fftwFloat
, alsa-lib
, libjack2
# drivers (optional):
, rtl-sdr
, hackrf
, pulseaudioSupport ? true, libpulseaudio
, portaudioSupport ? false, portaudio
}:

assert pulseaudioSupport -> libpulseaudio != null;
assert portaudioSupport -> portaudio != null;
# audio backends are mutually exclusive
assert !(pulseaudioSupport && portaudioSupport);

gnuradio3_8Minimal.pkgs.mkDerivation rec {
  pname = "gqrx";
  version = "2.15.7";

  src = fetchFromGitHub {
    owner = "gqrx-sdr";
    repo = "gqrx";
    rev = "v${version}";
    sha256 = "sha256-4tXWwBkVmNZ4s3d6/n6XBdbh9Fv7821L3vkYmjgv1ds=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    log4cpp
    mpir
    fftwFloat
    alsa-lib
    libjack2
    gnuradio3_8Minimal.unwrapped.boost
    qt5.qtbase
    qt5.qtsvg
    gnuradio3_8Minimal.pkgs.osmosdr
    rtl-sdr
    hackrf
  ] ++ lib.optionals (gnuradio3_8Minimal.hasFeature "gr-ctrlport") [
    thrift
    gnuradio3_8Minimal.unwrapped.python.pkgs.thrift
  ] ++ lib.optionals pulseaudioSupport [ libpulseaudio ]
    ++ lib.optionals portaudioSupport [ portaudio ];

  cmakeFlags =
    let
      audioBackend =
        if pulseaudioSupport
        then "Pulseaudio"
        else if portaudioSupport
        then "Portaudio"
        else "Gr-audio";
    in [
      "-DLINUX_AUDIO_BACKEND=${audioBackend}"
    ];

  meta = with lib; {
    description = "Software defined radio (SDR) receiver";
    longDescription = ''
      Gqrx is a software defined radio receiver powered by GNU Radio and the Qt
      GUI toolkit. It can process I/Q data from many types of input devices,
      including Funcube Dongle Pro/Pro+, rtl-sdr, HackRF, and Universal
      Software Radio Peripheral (USRP) devices.
    '';
    homepage = "https://gqrx.dk/";
    # Some of the code comes from the Cutesdr project, with a BSD license, but
    # it's currently unknown which version of the BSD license that is.
    license = licenses.gpl3Plus;
    platforms = platforms.linux;  # should work on Darwin / macOS too
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
