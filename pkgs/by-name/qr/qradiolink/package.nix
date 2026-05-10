{
  lib,
  fetchFromCodeberg,
  libpulseaudio,
  libconfig,
  pkg-config,
  # Needs a gnuradio built with qt gui support
  gnuradio,
  log4cpp,
  thrift,
  # Not gnuradioPackages'
  codec2,
  gmp,
  gsm,
  libopus,
  libjpeg,
  libsndfile,
  libftdi,
  limesuite,
  soapysdr-with-plugins,
  protobuf,
  speex,
  speexdsp,
  cppzmq,
  uhd,
}:

gnuradio.pkgs.mkDerivation rec {
  pname = "qradiolink";
  version = "0.10.2-1";

  src = fetchFromCodeberg {
    owner = "qradiolink";
    repo = "qradiolink";
    tag = version;
    hash = "sha256-pouOFi0w5QW3Wn6C5k+JB5wO+tX79rD+SshH+OitsDw=";
  };

  preBuild = ''
    cd src/ext
    protoc --cpp_out=. Mumble.proto
    protoc --cpp_out=. QRadioLink.proto
    cd -
  '';

  installPhase = ''
    install -Dm755 qradiolink -t $out/bin
    install -Dm644 qradiolink.desktop -t $out/share/applications
    install -Dm644 src/res/icon.png $out/share/pixmaps/qradiolink.png
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
    protobuf
  ]
  ++ lib.optionals (gnuradio.hasFeature "gr-ctrlport") [
    thrift
    gnuradio.unwrapped.python.pkgs.thrift
  ];
  nativeBuildInputs = [
    pkg-config
    protobuf
    gnuradio.qt.qmake
    gnuradio.qt.wrapQtAppsHook
  ];

  meta = {
    description = "SDR transceiver application for analog and digital modes";
    mainProgram = "qradiolink";
    homepage = "http://qradiolink.org/";
    license = with lib.licenses; [
      bsd2
      gpl3Only
      lgpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux;
  };
}
