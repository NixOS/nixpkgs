{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "livekit";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9YWZIZXXphsyYXaBFSUHNyulcBmob7vExkI+LM4DeFY=";
  };

  vendorHash = "sha256-Fa2GHoXP8jm5aiPXLz9newQR/KAoUgJ3Pv/Bw2IYsrA=";

  subPackages = [ "cmd/server" ];

  postInstall = ''
    mv $out/bin/server $out/bin/livekit-server
  '';

  passthru.tests = nixosTests.livekit;

  meta = {
    description = "End-to-end stack for WebRTC. SFU media server and SDKs";
    homepage = "https://livekit.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mgdelacroix ];
    mainProgram = "livekit-server";
  };
})
