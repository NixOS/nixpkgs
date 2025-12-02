{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go2rtc";
  version = "1.9.12";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "go2rtc";
    tag = "v${version}";
    hash = "sha256-NM8xH3HpfHOWVcOEM/bcWIwBSeKNLqhNfFTXE75xjH8=";
  };

  vendorHash = "sha256-iOMIbeNh2+tNSMc5BR2h29a7uAru9ER/tPBI59PeeDY=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false; # tests fail

  meta = {
    description = "Ultimate camera streaming application with support RTSP, RTMP, HTTP-FLV, WebRTC, MSE, HLS, MJPEG, HomeKit, FFmpeg, etc";
    homepage = "https://github.com/AlexxIT/go2rtc";
    changelog = "https://github.com/AlexxIT/go2rtc/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "go2rtc";
  };
}
