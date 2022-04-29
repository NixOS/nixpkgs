{ lib, stdenv, fetchFromGitHub, pkg-config, libusb1, rtl-sdr }:

stdenv.mkDerivation {
  pname = "rtl-ais";
  version = "0.8.1";
  buildInputs = [ pkg-config rtl-sdr libusb1 ];

  src = fetchFromGitHub {
    owner = "dgiardini";
    repo = "rtl-ais";
    rev = "0e85f4e5f9ce7378834c3129bc894580efc24291";
    sha256 = "0wm4zai1vs89mf0zgz52q5w5rj8f3i3v6zg42hfb7aqabi25r3jf";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A simple AIS tuner and generic dual-frequency FM demodulator";
    homepage = "https://github.com/dgiardini/rtl-ais";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mgdm ];
    mainProgram = "rtl_ais";
    platforms = platforms.unix;
  };
}
