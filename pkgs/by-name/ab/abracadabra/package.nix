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
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "KejPi";
    repo = "AbracaDABra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v8s3s2qWkE10zIsFL6aO9mESR4t6Yf941QETh2m+cHI=";
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
