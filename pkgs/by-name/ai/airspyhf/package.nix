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
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "airspy";
    repo = "airspyhf";
    # Not clear why upstream won't tag releases. See:
    # https://github.com/airspy/airspyhf/commit/c0bb66dd8976651c53884ccec3d70a108f1e50e1#r193607536
    rev = "c0bb66dd8976651c53884ccec3d70a108f1e50e1";
    hash = "sha256-7bXBv4YTOaWRFI6Svb9/lSBEAssUgJMqxKM5zHk1swM=";
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
    maintainers = with lib.maintainers; [
      aciceri
      sikmir
    ];
    platforms = lib.platforms.unix;
  };
}
