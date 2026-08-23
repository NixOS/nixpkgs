{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dfu-util";
  version = "0.11";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  src = fetchurl {
    url = "https://dfu-util.sourceforge.net/releases/dfu-util-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-tLU7ohqC7349TEffKVKt9fpJT0mbawtXxYxdBK6P8Z4=";
  };

  meta = {
    description = "Device firmware update (DFU) USB programmer";
    longDescription = ''
      dfu-util is a program that implements the host (PC) side of the USB
      DFU 1.0 and 1.1 (Universal Serial Bus Device Firmware Upgrade) protocol.

      DFU is intended to download and upload firmware to devices connected over
      USB. It ranges from small devices like micro-controller boards up to mobile
      phones. With dfu-util you are able to download firmware to your device or
      upload firmware from it.
    '';
    homepage = "https://dfu-util.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.fpletz ];
  };
})
