{ stdenv
, fetchFromGitHub
, pkgconfig
, libbladeRF
, libusb1
, ncurses
, rtl-sdr
}:

stdenv.mkDerivation rec {
  pname = "dump1090";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c30x56h79hza9m6b9zp5y28jxx4f4n5xgaaw597l8agcm5iia0p";
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

  meta = with stdenv.lib; {
    description = "A simple Mode S decoder for RTLSDR devices";
    homepage = "https://github.com/flightaware/dump1090";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ earldouglas ];
  };
}
