{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "livekit";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${version}";
    hash = "sha256-2MooX+wy7KetxEBgQoVoL4GuVkm+SbTzYgfWyLL7KU8=";
  };

  vendorHash = "sha256-8YR0Bl+sQsqpFtD+1GeYaydBdHeM0rRL2NbgAh9kCj0=";

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
