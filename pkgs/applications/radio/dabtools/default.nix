{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, libusb1, rtl-sdr, fftw
} :

stdenv.mkDerivation {
  pname = "dabtools";
  version = "20180405";

  src = fetchFromGitHub {
    owner = "Opendigitalradio";
    repo = "dabtools";
    rev = "8b0b2258b02020d314efd4d0d33a56c8097de0d1";
    sha256 = "18nkdybgg2w6zh56g6xwmg49sifalvraz4rynw8w5d8cqi3dm9sm";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ rtl-sdr fftw libusb1 ];

  meta = with lib; {
    description = "Commandline tools for DAB and DAB+ digital radio broadcasts";
    homepage = "https://github.com/Opendigitalradio/dabtools";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}

