{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "livekit";
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${version}";
    hash = "sha256-hDBdxuAWFJr5iAFOjGdUwO7zNgsVmFXIRaII1T5m20Y=";
  };

  vendorHash = "sha256-hgziX88Ty3HYQKgpgu/LqdtzqcfjZktZstsve6jVKk4=";

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
