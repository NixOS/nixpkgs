{ lib
, fetchFromGitHub
, libpulseaudio
, libconfig
# Needs a gnuradio built with qt gui support
, gnuradio3_8
# Not gnuradioPackages'
, codec2
, log4cpp
, gmp
, gsm
, libopus
, libjpeg
, libsndfile
, libftdi
, protobuf
, speex
, speexdsp
}:

gnuradio3_8.pkgs.mkDerivation rec {
  pname = "qradiolink";
  version = "0.8.5-2";

  src = fetchFromGitHub {
    owner = "qradiolink";
    repo = "qradiolink";
    rev = version;
    sha256 = "MgHfKR3AJW3pIN9oCBr4BWxk1fGSCpLmMzjxvuTmuFA=";
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
    log4cpp
    gmp
    libpulseaudio
    libconfig
    gsm
    gnuradio3_8.pkgs.osmosdr
    libopus
    libjpeg
    speex
    speexdsp
    gnuradio3_8.qt.qtbase
    gnuradio3_8.qt.qtmultimedia
    libftdi
    libsndfile
    gnuradio3_8.qwt
  ];
  nativeBuildInputs = [
    protobuf
    gnuradio3_8.qt.qmake
    gnuradio3_8.qt.wrapQtAppsHook
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "SDR transceiver application for analog and digital modes";
    homepage = "http://qradiolink.org/";
    license = licenses.agpl3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
