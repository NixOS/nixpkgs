{ lib, stdenv
, fetchFromGitHub
, pkg-config
, libbladeRF
, libusb1
, ncurses
, rtl-sdr
}:

stdenv.mkDerivation rec {
  pname = "dump1090";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fckfcgypmplzl1lidd04jxiabczlfx9mv21d6rbsfknghsjpn03";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libbladeRF
    libusb1
    ncurses
    rtl-sdr
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -v dump1090 view1090 $out/bin
    cp -vr public_html $out/share/dump1090

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple Mode S decoder for RTLSDR devices";
    homepage = "https://github.com/flightaware/dump1090";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ earldouglas ];
  };
}
