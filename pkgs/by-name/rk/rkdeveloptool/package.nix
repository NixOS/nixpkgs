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
  version = "unstable-2025-03-07";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkdeveloptool";
    rev = "304f073752fd25c854e1bcf05d8e7f925b1f4e14";
    sha256 = "sha256-GcSxkraJrDCz5ADO0XJk4xRrYTk0V5dAAim+D7ZiMJQ=";
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
