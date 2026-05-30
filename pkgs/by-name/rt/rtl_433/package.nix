{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  rtl-sdr,
  soapysdr-with-plugins,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "25.12";
  pname = "rtl_433";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = "rtl_433";
    rev = finalAttrs.version;
    hash = "sha256-VDNXLx6OUBQkflKFHp1LP8N5g15o6vYg3P9XWgIoYIg=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    libusb1
    rtl-sdr
    soapysdr-with-plugins
  ];

  doCheck = true;

  meta = {
    description = "Decode traffic from devices that broadcast on 433.9 MHz, 868 MHz, 315 MHz, 345 MHz and 915 MHz";
    homepage = "https://github.com/merbanan/rtl_433";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      earldouglas
      markuskowa
    ];
    platforms = lib.platforms.all;
    mainProgram = "rtl_433";
  };
})
