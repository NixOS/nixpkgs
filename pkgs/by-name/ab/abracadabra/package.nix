{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "KejPi";
    repo = "AbracaDABra";
    rev = "v${version}";
    hash = "sha256-kH84xDK1873ekxIYlOw6M3kVH+Sm/Sofb3AAbs4XzE0=";
  };

  patches = [
    # upstream patches, remove with next upgrade
    (fetchpatch {
      name = "no-qcustomplot";
      url = "https://github.com/KejPi/AbracaDABra/commit/b0800cfe7abebf79f1edb915b3cf55fe96129017.patch";
      hash = "sha256-8FiXix/riLvkxd2uTJCoUESInPiCsF6B+qaxRGbeUcs=";
    })
    (fetchpatch {
      name = "fix-missing-include";
      url = "https://github.com/KejPi/AbracaDABra/commit/8f88a3351fccea93c3c83bbfa94e98fb0823b0ae.patch";
      hash = "sha256-9AloBgpUuewUBGM/NTHYUqd0uctJ17QJ0GA5RJN1GLQ=";
    })
  ];

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
