{
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.9.1-3";

  src = fetchFromGitHub {
    owner = "qradiolink";
    repo = "qradiolink";
    tag = version;
    hash = "sha256-0inXfeOSVmJYtNhD6WBExjT43STfBjePomKILxoHO6Q=";
  };

  patches = [
    # dmr: add explicit cstdint import
    (fetchpatch {
      url = "https://github.com/qradiolink/qradiolink/pull/131/commits/bdd3b47708edf42b281fb9e5507d356d475f3df9.patch";
      hash = "sha256-Uoi8/IK8yBmfPL7RAkCGuyHdcdJZ+YMxccviY7Z+hXs=";
    })
    # qmake: find protobuf via pkg-config
    (fetchpatch {
      url = "https://github.com/qradiolink/qradiolink/pull/132/commits/cd3e4bc188a60bc85693fe3de4540c48f325deb4.patch";
      hash = "sha256-ufSStm0pyDkCUIx0SjVVHZhA4gW7Ip6PiexPg34DsCo=";
    })
  ];

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
