{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go2rtc";
  version = "1.9.10";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "go2rtc";
    tag = "v${version}";
    hash = "sha256-SWFVcfOfSCKuNJlahsZRY21n17vL1VjtDRiSZ5o3VGc=";
  };

  vendorHash = "sha256-k01+xngNA4SMCJa9Vhg+MxDgf973sUcrVXppwAz4MBs=";

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
