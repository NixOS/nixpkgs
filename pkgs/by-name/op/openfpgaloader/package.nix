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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "trabucayre";
    repo = "openFPGALoader";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GPYYvsMSzgZCU4qaANaP3nTa6ooJ7pjJDIzW0H4juQM=";
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
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
