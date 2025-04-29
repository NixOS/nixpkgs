{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb-compat-0_1,
  readline,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libnfc";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = "libnfc";
    rev = "libnfc-${version}";
    sha256 = "5gMv/HajPrUL/vkegEqHgN2d6Yzf01dTMrx4l34KMrQ=";
  };

  nativeBuildInputs = [
    # Note: Use autotools instead of cmake to build for darwin.
    # When built with cmake, the following error occurs on real device like PN532:
    # ```
    # $ LIBNFC_DEVICE=pn532_uart:/dev/tty.usbserial-110 nfc-list
    # nfc-list uses libnfc 1.8.0
    # error       libnfc.bus.uart Unable to set serial port speed to 115200 baud. Speed value must be one of those defined in termios(3).
    # error       libnfc.driver.pn532_uart        pn53x_check_communication error
    # nfc-list: ERROR: Unable to open NFC device: pn532_uart:/dev/tty.usbserial-110
    # ```
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    readline
  ];

  propagatedBuildInputs = [
    libusb-compat-0_1
  ];

  configureFlags = [
    "sysconfdir=/etc"
  ];

  meta = with lib; {
    description = "Library for Near Field Communication (NFC)";
    homepage = "https://github.com/nfc-tools/libnfc";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
