{ lib
, fetchFromGitHub
, libpulseaudio
, libconfig
# Needs a gnuradio built with qt gui support
, gnuradio
, log4cpp
, thrift
# Not gnuradioPackages'
, codec2
, gmp
, gsm
, libopus
, libjpeg
, libsndfile
, libftdi
, limesuite
, soapysdr-with-plugins
, protobuf
, speex
, speexdsp
, cppzmq
, uhd
}:

gnuradio.pkgs.mkDerivation rec {
  pname = "qradiolink";
  # https://github.com/qradiolink/qradiolink/tree/gr_3.10
  version = "0.9.0-1-unstable-2024-08-29";

  src = fetchFromGitHub {
    owner = "qradiolink";
    repo = "qradiolink";
    rev = "f1006a20e0a642d0ac20aab18b19fa97567f2621";
    sha256 = "sha256-9AYFO+mmwLAH8gEpZn6qcENabc/KBMcg/0wCTKsInNY=";
  };

  preBuild = ''
    cd src/ext
    protoc --cpp_out=. Mumble.proto
    protoc --cpp_out=. QRadioLink.proto
    cd ../..
    qmake
  '';

  installPhase = ''
    install -D qradiolink $out/bin/qradiolink
    install -Dm644 src/res/icon.png $out/share/pixmaps/qradiolink.png
    install -Dm644 qradiolink.desktop $out/share/applications/qradiolink.desktop
  '';

  buildInputs = [
    gnuradio.unwrapped.boost
    codec2
    gnuradio.unwrapped.logLib
    # gnuradio uses it's own log library (spdlog), and qradiolink is still
    # using the old gnuradio log library log4cpp. Perhaps this won't be needed
    # once the gr_3.10 branch will mature enough to be merged into qradiolink's
    # master branch.
    log4cpp
    gmp
    libpulseaudio
    libconfig
    gsm
    gnuradio.pkgs.osmosdr
    libopus
    libjpeg
    limesuite
    soapysdr-with-plugins
    speex
    speexdsp
    gnuradio.qt.qtbase
    gnuradio.qt.qtmultimedia
    libftdi
    libsndfile
    cppzmq
    gnuradio.qwt
    uhd
  ] ++ lib.optionals (gnuradio.hasFeature "gr-ctrlport") [
    thrift
    gnuradio.unwrapped.python.pkgs.thrift
  ];
  nativeBuildInputs = [
    protobuf
    gnuradio.qt.qmake
    gnuradio.qt.wrapQtAppsHook
  ];

  meta = with lib; {
    description = "SDR transceiver application for analog and digital modes";
    mainProgram = "qradiolink";
    homepage = "http://qradiolink.org/";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
