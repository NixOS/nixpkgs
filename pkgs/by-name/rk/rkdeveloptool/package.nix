{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation {
  pname = "rkdeveloptool";
  version = "unstable-2021-04-08";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkdeveloptool";
    rev = "46bb4c073624226c3f05b37b9ecc50bbcf543f5a";
    sha256 = "eIFzyoY6l3pdfCN0uS16hbVp0qzdG3MtcS1jnDX1Yk0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libusb1 ];

  # main.cpp:1568:36: error: '%s' directive output may be truncated writing up to 557 bytes into a region of size 5
  CPPFLAGS = lib.optionals stdenv.cc.isGNU [ "-Wno-error=format-truncation" ];

  meta = with lib; {
    homepage = "https://github.com/rockchip-linux/rkdeveloptool";
    description = "Tool from Rockchip to communicate with Rockusb devices";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.lopsided98 ];
    mainProgram = "rkdeveloptool";
  };
}
