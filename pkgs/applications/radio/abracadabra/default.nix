{ lib, stdenv, fetchFromGitHub, cmake, wrapQtAppsHook
, qtbase, qtmultimedia, qttools
, faad2, mpg123, portaudio
, libusb1, rtl-sdr, airspy, soapysdr-with-plugins
} :

stdenv.mkDerivation rec {
  pname = "abracadabra";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "KejPi";
    repo = "AbracaDABra";
    rev = "v${version}";
    hash = "sha256-viB6vRqBvYbFJh6wYs7kIk4sY9SZHRz1KlHJ3DTwUFQ=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    faad2
    mpg123
    portaudio
    libusb1
    rtl-sdr
    airspy
    soapysdr-with-plugins
  ];

  cmakeFlags = [
    "-DAIRSPY=ON"
    "-DSOAPYSDR=ON"
  ];

  meta = with lib; {
    description = "DAB/DAB+ radio application";
    homepage = "https://github.com/KejPi/AbracaDABra";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.markuskowa ];
    mainProgram = "AbracaDABra";
  };
}

