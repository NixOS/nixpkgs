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
}:

assert pulseaudioSupport -> libpulseaudio != null;

gnuradio3_8Minimal.pkgs.mkDerivation rec {
  pname = "gqrx";
  version = "2.14.6";

  src = fetchFromGitHub {
    owner = "csete";
    repo = "gqrx";
    rev = "v${version}";
    sha256 = "sha256-DMmQXcGPudAVOwuc+LVrcIzfwMMQVBZPbM6Bt1w56D8=";
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
  ] ++ lib.optionals pulseaudioSupport [ libpulseaudio ];

  postInstall = ''
    install -vD $src/gqrx.desktop -t "$out/share/applications/"
    install -vD $src/resources/icons/gqrx.svg -t "$out/share/pixmaps/"
  '';

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
