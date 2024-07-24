{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "livekit";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${version}";
    hash = "sha256-wUMp2U++6LQm8Iyv6CI8NSoc1sL2k/N12m4FVr35RS0=";
  };

  vendorHash = "sha256-SN92BqNsbtXHwIcEk6AmVLoKyPr8Pn4MbKEIYS4ZodQ=";

  subPackages = [ "cmd/server" ];

  postInstall = ''
    mv $out/bin/server $out/bin/livekit-server
  '';

  meta = with lib; {
    description = "End-to-end stack for WebRTC. SFU media server and SDKs";
    homepage = "https://livekit.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mgdelacroix ];
    mainProgram = "livekit-server";
  };
}
