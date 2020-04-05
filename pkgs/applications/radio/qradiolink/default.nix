{ stdenv
, fetchFromGitHub
, pkg-config
, qmake
, qtmultimedia
, libsndfile
, libftdi
, alsaLib
, boost
, libpulseaudio
, codec2
, libconfig
, gnuradio
, libopus
, libjpeg
, protobuf
, speex
} :

stdenv.mkDerivation rec {
  pname = "qradiolink";
  version = "0.8.2-3";

  src = fetchFromGitHub {
    owner = "kantooon";
    repo = "qradiolink";
    rev = version;
    sha256 = "11r93i7w3a3iaamlj7bis57qk7p74iq7ffcbmi89ac3mcf425csj";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
  ];

  preBuild = ''
    cd ext
    protoc --cpp_out=. Mumble.proto
    protoc --cpp_out=. QRadioLink.proto
    cd ..
    qmake
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp qradiolink $out/bin
  '';

  buildInputs = [
    gnuradio
    qtmultimedia
    libsndfile
    libftdi
    alsaLib
    boost
    libpulseaudio
    codec2
    libconfig
    libopus
    libjpeg
    protobuf
    speex
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "SDR transceiver application for analog and digital modes";
    homepage = "http://qradiolink.org/";
    license = licenses.agpl3;
    # See https://github.com/qradiolink/qradiolink/issues/67
    broken = true;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
