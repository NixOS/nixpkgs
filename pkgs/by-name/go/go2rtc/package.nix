{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go2rtc";
  version = "1.9.14";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "go2rtc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LwMQeRUIIsbsxaX9EItmlGSab4ssidI2Eklw39hXEHQ=";
  };

  vendorHash = "sha256-fbDHuLuajAMOQwqyvLdQJYglcygjo4EDqPEjeiSWz2Y=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false; # tests fail

  meta = {
    description = "Ultimate camera streaming application with support RTSP, RTMP, HTTP-FLV, WebRTC, MSE, HLS, MJPEG, HomeKit, FFmpeg, etc";
    homepage = "https://github.com/AlexxIT/go2rtc";
    changelog = "https://github.com/AlexxIT/go2rtc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "go2rtc";
  };
})
