{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation {
  pname = "airspyhf";
  version = "1.6.8-unstable-2025-07-12";

  src = fetchFromGitHub {
    owner = "airspy";
    repo = "airspyhf";
    rev = "87cf12a30f3a0f10f313aab8e54999ca69b753af";
    hash = "sha256-7bXBv4YTOaWRFI6Svb9/lSBEAssUgJMqxKM5zHk1swM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libusb1 ];

  meta = with lib; {
    description = "User mode driver for Airspy HF+";
    homepage = "https://github.com/airspy/airspyhf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
