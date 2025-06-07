{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "livekit";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${version}";
    hash = "sha256-xj0K9DaLXrj7U9zlaaAOMu7HFkTvn6P9PBb83j26D70=";
  };

  vendorHash = "sha256-3zrP84YkPRn4NC3l9XRhtNraX8G5WnRxo2CNOmMfVJs=";

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
