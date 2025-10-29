{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  name = "rtl8761b-firmware";

  src = fetchFromGitHub {
    owner = "Realtek-OpenSource";
    repo = "android_hardware_realtek";
    rev = "rtk1395";
    sha256 = "sha256-vd9sZP7PGY+cmnqVty3sZibg01w8+UNinv8X85B+dzc=";
  };

  installPhase = ''
    install -D -pm644 \
      bt/rtkbt/Firmware/BT/rtl8761b_fw \
      $out/lib/firmware/rtl_bt/rtl8761b_fw.bin

    install -D -pm644 \
      bt/rtkbt/Firmware/BT/rtl8761b_config \
      $out/lib/firmware/rtl_bt/rtl8761b_config.bin
  '';

  meta = {
    description = "Firmware for Realtek RTL8761b";
    license = lib.licenses.unfreeRedistributableFirmware;
    maintainers = with lib.maintainers; [ milibopp ];
    platforms = with lib.platforms; linux;
  };
}
