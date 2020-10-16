{ lib
, mkDerivation
, fetchFromGitHub
, libpulseaudio
, libconfig
, gnuradio
, gnuradioPackages
, gsm
, libopus
, libjpeg
, protobuf
, speex
, qmake4Hook
} :

let
  version = "0.5.0";

in mkDerivation {
  pname = "qradiolink";
  inherit version;

  src = fetchFromGitHub {
    owner = "kantooon";
    repo = "qradiolink";
    rev = version;
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
    libpulseaudio
    libconfig
    gsm
    gnuradioPackages.osmosdr
    libopus
    libjpeg
    speex
  ];
  nativeBuildInputs = [
    protobuf
    qmake4Hook
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
