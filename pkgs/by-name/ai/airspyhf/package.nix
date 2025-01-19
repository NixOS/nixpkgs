{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "airspyhf";
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "airspy";
    repo = pname;
    rev = version;
    hash = "sha256-RKTMEDPeKcerJZtXTn8eAShxDcZUMgeQg/+7pEpMyVg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libusb1 ];

  meta = {
    description = "User mode driver for Airspy HF+";
    homepage = "https://github.com/airspy/airspyhf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
}
