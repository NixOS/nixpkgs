{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmirisdr";
  version = "2.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "libmirisdr-4";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HH9FEBcZdHvl5mEPduaIojQtFEIZaA2c4qUcHd7EVvk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  meta = {
    description = "Driver and utilities for Mirics MSI2500/MSI001 SDR devices";
    homepage = "https://github.com/f4exb/libmirisdr-4";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.db8le ];
    platforms = lib.platforms.unix;
  };
})
