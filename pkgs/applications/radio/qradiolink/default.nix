{ stdenv, fetchFromGitHub, alsaLib, boost
, qt4, libpulseaudio, codec2, libconfig
, gnuradio, gr-osmosdr, gsm
, libopus, libjpeg, protobuf, qwt, speex
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
    qt4
    alsaLib
    boost
    libpulseaudio
    codec2
    libconfig
    gsm
    gnuradio
    gr-osmosdr
    libopus
    libjpeg
    protobuf
    speex
    qwt
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "SDR transceiver application for analog and digital modes";
    homepage = "http://qradiolink.org/";
    license = licenses.agpl3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
