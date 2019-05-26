{ stdenv, fetchurl, pkgconfig, libusb1-axoloti }:

stdenv.mkDerivation rec {
  name="dfu-util-${version}";
  version = "0.8";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1-axoloti ];

  src = fetchurl {
    url = "http://dfu-util.sourceforge.net/releases/${name}.tar.gz";
    sha256 = "0n7h08avlzin04j93m6hkq9id6hxjiiix7ff9gc2n89aw6dxxjsm";
  };

  meta = with stdenv.lib; {
    description = "Device firmware update (DFU) USB programmer";
    longDescription = ''
      dfu-util is a program that implements the host (PC) side of the USB
      DFU 1.0 and 1.1 (Universal Serial Bus Device Firmware Upgrade) protocol.

      DFU is intended to download and upload firmware to devices connected over
      USB. It ranges from small devices like micro-controller boards up to mobile
      phones. With dfu-util you are able to download firmware to your device or
      upload firmware from it.
    '';
    homepage = http://dfu-util.sourceforge.net;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
