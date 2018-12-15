{ stdenv, fetchFromGitHub, alsaLib, boost
, qt4, libpulseaudio, codec2, libconfig
, gnuradio, gnuradio-osmosdr, gsm
, libopus, libjpeg, protobuf, qwt, speex
} :

let
  version = "0.5.0";

in stdenv.mkDerivation {
  name = "qradiolink-${version}";

  src = fetchFromGitHub {
    owner = "kantooon";
    repo = "qradiolink";
    rev = "${version}";
    sha256 = "0xhg5zhjznmls5m3rhpk1qx0dipxmca12s85w15d0i7qwva2f1gi";
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
    gnuradio-osmosdr
    libopus
    libjpeg
    protobuf
    speex
    qwt
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "SDR transceiver application for analog and digital modes";
    homepage = http://qradiolink.org/;
    license = licenses.agpl3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
