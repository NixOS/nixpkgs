{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "livekit";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${version}";
    hash = "sha256-tgoVHRv8hnDkjFYShZ/3lieknhIobHv27RVvQOCtEWU=";
  };

  vendorHash = "sha256-TZ435gu5naFi/JLz6B/1fpvGA3diJp4JIWL1zgNlb4Q=";

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
