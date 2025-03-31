{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  faad2,
  mpg123,
  portaudio,
  libusb1,
  rtl-sdr,
  airspy,
  soapysdr-with-plugins,
}:

stdenv.mkDerivation rec {
  pname = "abracadabra";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "KejPi";
    repo = "AbracaDABra";
    rev = "v${version}";
    hash = "sha256-yCjMinDCoBTOC5Ks4MUd0MQeitfrIe8bI3Q4ahz36kQ=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtlocation
    qt6.qtpositioning
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
