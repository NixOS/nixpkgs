{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb-compat-0_1,
  readline,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libnfc";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = pname;
    rev = "libnfc-${version}";
    sha256 = "5gMv/HajPrUL/vkegEqHgN2d6Yzf01dTMrx4l34KMrQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb-compat-0_1
    readline
  ];

  configureFlags = [
    "sysconfdir=/etc"
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-DLIBNFC_DRIVER_PN532_I2C=OFF"
    "-DLIBNFC_DRIVER_PN532_SPI=OFF"
  ];

  meta = with lib; {
    description = "Library for Near Field Communication (NFC)";
    homepage = "https://github.com/nfc-tools/libnfc";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
