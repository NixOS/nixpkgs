{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "livekit";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${version}";
    hash = "sha256-z3xXvs31SMEq0Wfhm/v+7iznCsz/kNqwhQsMueQmEhw=";
  };

  vendorHash = "sha256-aVKCDDlCkFlFa88H1UAR98Hai5junVWVxVZPK5i+nM8=";

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
