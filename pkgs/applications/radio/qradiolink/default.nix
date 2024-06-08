{ lib
, fetchFromGitHub
, libpulseaudio
, libconfig
# Needs a gnuradio built with qt gui support
, gnuradio3_8
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
}:

gnuradio3_8.pkgs.mkDerivation rec {
  pname = "qradiolink";
  version = "0.8.11-1";

  src = fetchFromGitHub {
    owner = "qradiolink";
    repo = "qradiolink";
    rev = version;
    sha256 = "sha256-62+eKaLt9DlTebbnLPVJFx68bfWb7BrdQHocyJTfK28=";
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
    gnuradio3_8.unwrapped.boost
    codec2
    gnuradio3_8.unwrapped.logLib
    gmp
    libpulseaudio
    libconfig
    gsm
    gnuradio3_8.pkgs.osmosdr
    libopus
    libjpeg
    limesuite
    soapysdr-with-plugins
    speex
    speexdsp
    gnuradio3_8.qt.qtbase
    gnuradio3_8.qt.qtmultimedia
    libftdi
    libsndfile
    cppzmq
    gnuradio3_8.qwt
  ] ++ lib.optionals (gnuradio3_8.hasFeature "gr-ctrlport") [
    thrift
    gnuradio3_8.unwrapped.python.pkgs.thrift
  ];
  nativeBuildInputs = [
    protobuf
    gnuradio3_8.qt.qmake
    gnuradio3_8.qt.wrapQtAppsHook
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
