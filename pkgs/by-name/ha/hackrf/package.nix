{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  fftwSinglePrec,
}:

stdenv.mkDerivation rec {
  pname = "hackrf";
  version = "2026.01.1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "hackrf";
    rev = "v${version}";
    sha256 = "sha256-phlfltAMen5g/AcUOdAcOvIZgQdYSdEYzoEVvUTI6G4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
    fftwSinglePrec
  ];

  cmakeFlags = [
    "-DUDEV_RULES_GROUP=plugdev"
    "-DUDEV_RULES_PATH=lib/udev/rules.d"
  ];

  preConfigure = ''
    cd host
  '';

  doInstallCheck = true;

  meta = {
    description = "Open source SDR platform";
    homepage = "https://greatscottgadgets.com/hackrf/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ sjmackenzie ];
  };
}
