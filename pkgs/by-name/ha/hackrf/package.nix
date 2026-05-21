{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  fftwSinglePrec,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hackrf";
  version = "2026.01.3";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "hackrf";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-/RSZ+jkh4wmb0n8Kiee9Nr5D6LPYdmZVigpsBagAaLg=";
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
})
