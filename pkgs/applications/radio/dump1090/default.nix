{ lib, stdenv
, fetchFromGitHub
, pkgconfig
, libbladeRF
, libusb1
, ncurses
, rtl-sdr
}:

stdenv.mkDerivation rec {
  pname = "dump1090";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zacsqaqsiapljhzw31dwc4nld2rp98jm3ivkyznrhzk9n156p42";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    libbladeRF
    libusb1
    ncurses
    rtl-sdr
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp -v dump1090 view1090 $out/bin
    cp -vr public_html $out/share/dump1090
  '';

  meta = with lib; {
    description = "A simple Mode S decoder for RTLSDR devices";
    homepage = "https://github.com/flightaware/dump1090";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ earldouglas ];
  };
}
