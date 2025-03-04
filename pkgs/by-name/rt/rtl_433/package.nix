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

stdenv.mkDerivation rec {
  version = "25.02";
  pname = "rtl_433";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = "rtl_433";
    rev = version;
    hash = "sha256-S0jtcgbpS2NOezZJ0uq1pVj0nsa82F0NRmQD9glILz4=";
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

  meta = with lib; {
    description = "Decode traffic from devices that broadcast on 433.9 MHz, 868 MHz, 315 MHz, 345 MHz and 915 MHz";
    homepage = "https://github.com/merbanan/rtl_433";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      earldouglas
      markuskowa
    ];
    platforms = platforms.all;
    mainProgram = "rtl_433";
  };
}
