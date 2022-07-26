{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, fetchpatch
, libusb1, rtl-sdr, soapysdr-with-plugins
}:

stdenv.mkDerivation rec {
  version = "21.12";
  pname = "rtl_433";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = "rtl_433";
    rev = version;
    sha256 = "sha256-KoDKyI7KDdGSe79ZTuL9ObKnOJsqTN4wrMq+/cvQ/Xk=";
  };

  patches = [( fetchpatch {
    name = "CVE-2022-27419";
    url = "https://github.com/merbanan/rtl_433/commit/37455483889bd1c641bdaafc493d1cc236b74904.patch";
    sha256 = "172jndh8x5nlcbx2jp5y8fgfxsawwfz95037pcjp170gf93ijy88";
  })];

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ libusb1 rtl-sdr soapysdr-with-plugins ];

  doCheck = true;

  meta = with lib; {
    description = "Decode traffic from devices that broadcast on 433.9 MHz, 868 MHz, 315 MHz, 345 MHz and 915 MHz";
    homepage = "https://github.com/merbanan/rtl_433";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ earldouglas markuskowa ];
    platforms = platforms.all;
  };

}
