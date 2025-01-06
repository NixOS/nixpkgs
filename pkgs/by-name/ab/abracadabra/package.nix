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
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "KejPi";
    repo = "AbracaDABra";
    rev = "v${version}";
    hash = "sha256-PPG71W5HeLr4R8je88K4VXPiSbJn5T7dP3M05C+bkv0=";
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
