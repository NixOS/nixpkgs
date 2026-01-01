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
<<<<<<< HEAD
  version = "25.12";
=======
  version = "25.02";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "rtl_433";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = "rtl_433";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-VDNXLx6OUBQkflKFHp1LP8N5g15o6vYg3P9XWgIoYIg=";
=======
    hash = "sha256-S0jtcgbpS2NOezZJ0uq1pVj0nsa82F0NRmQD9glILz4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Decode traffic from devices that broadcast on 433.9 MHz, 868 MHz, 315 MHz, 345 MHz and 915 MHz";
    homepage = "https://github.com/merbanan/rtl_433";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      earldouglas
      markuskowa
    ];
    platforms = lib.platforms.all;
=======
  postPatch = ''
    substituteInPlace ./CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.6)" \
      "cmake_minimum_required(VERSION 2.6...3.10)"
  '';

  meta = with lib; {
    description = "Decode traffic from devices that broadcast on 433.9 MHz, 868 MHz, 315 MHz, 345 MHz and 915 MHz";
    homepage = "https://github.com/merbanan/rtl_433";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      earldouglas
      markuskowa
    ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "rtl_433";
  };
}
