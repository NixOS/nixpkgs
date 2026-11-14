{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "livekit";
  version = "1.13.11";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-01HXiAbZEdnDd5lYwFyStIcHUINiPimDu38HpXut2YQ=";
  };

  vendorHash = "sha256-8tQI9KRMV4YXAT1Hoz/hLJ4RD1G4MrSsqv5o3xXG9YY=";

  subPackages = [ "cmd/server" ];

  postInstall = ''
    mv $out/bin/server $out/bin/livekit-server
  '';

  passthru.tests = nixosTests.livekit;

  meta = {
    description = "End-to-end stack for WebRTC. SFU media server and SDKs";
    homepage = "https://livekit.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mgdelacroix
      liamthexpl0rer
    ];
    mainProgram = "livekit-server";
  };
})
