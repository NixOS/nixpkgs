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

stdenv.mkDerivation (finalAttrs: {
  pname = "abracadabra";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "KejPi";
    repo = "AbracaDABra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jkbeu5KW4fB1d3RRCBO79ZeujrbzHuVu9kQ3EuwVHoE=";
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

  meta = {
    description = "DAB/DAB+ radio application";
    homepage = "https://github.com/KejPi/AbracaDABra";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ markuskowa ];
    mainProgram = "AbracaDABra";
  };
})
