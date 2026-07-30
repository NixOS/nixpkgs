{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "livekit";
  version = "1.13.4";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XdyXjDI9q1RjdLY19O2Gzp/KBTLk88soB5W60y9hFCs=";
  };

  vendorHash = "sha256-wHra0WyEnN8bfBi2MWJaZmWwVeSchzN18zbu2hzJw5Q=";

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
