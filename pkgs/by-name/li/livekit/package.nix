{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "livekit";
  version = "1.9.11";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mmDTY4nWUowSHPTSlvfVaNlv0Rp176H5FvJsYrNnt/8=";
  };

  vendorHash = "sha256-yEAIfef7Ryepcpq9Te+Iamod1SfqXZoluhFaYGYcsVc=";

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
