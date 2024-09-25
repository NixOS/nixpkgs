{
  stdenv,
  lib,
  fetchzip,
  cmake,
  cups,
}:

stdenv.mkDerivation rec {
  pname = "magicard-cups-driver";
  version = "1.4.0";

  src = fetchzip {
    # https://support.magicard.com/solution/linux-driver/
    url = "https://f08ddbe93aa02eaf9a6c-f08cd513e3a8c914f4f8f62af1786149.ssl.cf3.rackcdn.com/magicard_ltd-linux_driver-${version}.tar.gz";
    hash = "sha256-1k2Twn1JBizw/tzQ0xF1uJIecblRd6VurB7FAUop5F0=";
  };

  src_v1_3_4 = fetchzip {
    url = "https://techs.magicard.com/linux/v1.3.4/magicard_ltd-linux_driver-1.3.4.tar.gz";
    hash = "sha256-6UIL2wyFOjOJeyGjYScfjbpURycN469raye6DnP19jg=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ cups ];

  # Replace the supplied cmake generated makefile (which is useless on a different machine)
  # with the CMakeLists.txt taken from v1.3.4 of the driver and patch it to make it compatible with v1.4.0
  prePatch = ''
    cp ${src_v1_3_4}/CMakeLists.txt CMakeLists.txt
    rm makefile
  '';

  patches = [ ./CMakeLists.patch ];

  cmakeFlags = [
    "-DCUPS_SERVER_BIN=lib/cups"
    "-DCUPS_DATA_DIR=share/cups"
  ];

  meta = {
    description = "CUPS driver for Magicard Printers";
    longDescription = ''
      This driver supports Magicard printers and rebrands sold at least under the following brands:

      - Aisino
      - AlphaCard
      - BOOD
      - Brady
      - Cardmaker
      - Centena
      - DTP
      - Digital ID
      - DoH
      - Elliaden
      - Fagoo
      - Goodcard
      - Gudecard
      - IDentilam
      - IDville
      - ilinkcard
      - Intersider
      - Magicard
      - Orphicard
      - PPC ID
      - Polaroid
      - PriceCardPro
      - Pridento
      - ScreenCheck
      - Titan
      - Ying
    '';
    homepage = "https://support.magicard.com/solution/linux-driver/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _0x3f ];
  };
}
