{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go2rtc";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "go2rtc";
    tag = "v${version}";
    hash = "sha256-TUUIEr90ZUMxsuF86CWZVpfo277mnefJ/ofPgwpKhcE=";
  };

  vendorHash = "sha256-BU31vb+qhMQtO9PXUjrQP3mEA0iOTEK/ZYXW6jL0UNo=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false; # tests fail

  meta = with lib; {
    description = "Ultimate camera streaming application with support RTSP, RTMP, HTTP-FLV, WebRTC, MSE, HLS, MJPEG, HomeKit, FFmpeg, etc";
    homepage = "https://github.com/AlexxIT/go2rtc";
    changelog = "https://github.com/AlexxIT/go2rtc/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "go2rtc";
  };
}
