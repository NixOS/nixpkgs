{
  cmake,
  fetchFromGitHub,
  hidapi,
  lib,
  libftdi1,
  libusb1,
  pkg-config,
  stdenv,
  udev,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openfpgaloader";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "trabucayre";
    repo = "openFPGALoader";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xz5acJJLRfWsJmcPL3R2PWwZgnBRUHibkGf1sHVUPn4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hidapi
    libftdi1
    libusb1
    zlib
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform udev) [
    udev
  ];

  meta = {
    description = "Universal utility for programming FPGAs";
    mainProgram = "openFPGALoader";
    homepage = "https://github.com/trabucayre/openFPGALoader";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
