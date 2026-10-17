{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libusb1,
  rtl-sdr,
}:

stdenv.mkDerivation {
  pname = "rtl-ais";
  version = "0.8.1";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    rtl-sdr
    libusb1
  ];

  src = fetchFromGitHub {
    owner = "dgiardini";
    repo = "rtl-ais";
    rev = "0e85f4e5f9ce7378834c3129bc894580efc24291";
    hash = "sha256-To5cRFwKq7McFOR9s0ccDslceMGi/PeBqwnpHaL6pHI=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple AIS tuner and generic dual-frequency FM demodulator";
    homepage = "https://github.com/dgiardini/rtl-ais";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ mgdm ];
    mainProgram = "rtl_ais";
    platforms = lib.platforms.unix;
  };
}
