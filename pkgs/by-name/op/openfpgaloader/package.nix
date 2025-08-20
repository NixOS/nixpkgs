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
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "trabucayre";
    repo = "openFPGALoader";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iJSTiOcW15q3mWmMhe5wmO11cu2xfAI9zCsoB33ujWQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
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
