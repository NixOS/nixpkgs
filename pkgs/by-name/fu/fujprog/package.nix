{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libftdi1,
  libusb-compat-0_1,
}:

stdenv.mkDerivation rec {
  pname = "fujprog";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "kost";
    repo = "fujprog";
    rev = "v${version}";
    sha256 = "08kzkzd5a1wfd1aycywdynxh3qy6n7z9i8lihkahmb4xac3chmz5";
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
    maintainers = with lib.maintainers; [ trepetti ];
    platforms = lib.platforms.all;
    changelog = "https://github.com/kost/fujprog/releases/tag/v${version}";
  };
}
