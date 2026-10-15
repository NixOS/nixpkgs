{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libftdi1,
  libusb-compat-0_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fujprog";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "kost";
    repo = "fujprog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5VfIBlOdrArVhJGimP6xxuMBu/WNe+ZVaI4HVdqffyI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libftdi1
    libusb-compat-0_1
  ];

  meta = {
    description = "JTAG programmer for the ULX3S and ULX2S open hardware FPGA development boards";
    mainProgram = "fujprog";
    homepage = "https://github.com/kost/fujprog";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.all;
    changelog = "https://github.com/kost/fujprog/releases/tag/v${finalAttrs.version}";
  };
})
