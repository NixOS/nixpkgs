{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "livekit";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${version}";
    hash = "sha256-9di+WCu19cjJXBjtQN29JpGUEFygcIYTJXrdRwSg+TE=";
  };

  vendorHash = "sha256-FM7ORm4loMi06T5eAs8KiKFErcXk4XV8yLQYFy3uBRM=";

  subPackages = [ "cmd/server" ];

  postInstall = ''
    mv $out/bin/server $out/bin/livekit-server
  '';

  passthru.tests = nixosTests.livekit;

  meta = with lib; {
    description = "End-to-end stack for WebRTC. SFU media server and SDKs";
    homepage = "https://livekit.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mgdelacroix ];
    mainProgram = "livekit-server";
  };
}
