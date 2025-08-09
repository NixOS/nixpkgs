{
  lib,
  stdenv,
  fetchurl,
  libusb-compat-0_1,
}:
stdenv.mkDerivation rec {
  pname = "dfu-programmer";
  version = "0.7.2";

  buildInputs = [ libusb-compat-0_1 ];

  src = fetchurl {
    url = "mirror://sourceforge/dfu-programmer/${pname}-${version}.tar.gz";
    sha256 = "15gr99y1z9vbvhrkd25zqhnzhg6zjmaam3vfjzf2mazd39mx7d0x";
  };

  configureFlags = [ "--disable-libusb_1_0" ];

  meta = with lib; {
    license = licenses.gpl2;
    description = "Device Firmware Update based USB programmer for Atmel chips with a USB bootloader";
    mainProgram = "dfu-programmer";
    homepage = "http://dfu-programmer.sourceforge.net/";
    platforms = platforms.unix;
  };
}
