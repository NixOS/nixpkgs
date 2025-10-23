{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "livekit";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${version}";
    hash = "sha256-a0WaF9myP0xjTjfum+K7Wk86HOZP00kvjOYLmeEQdxk=";
  };

  vendorHash = "sha256-hYetTszLS/zYQ39wOv+sP8HlIiyBoKI3Z7XpOrffHa8=";

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
