{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "livekit-cli";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    rev = "v${version}";
    hash = "sha256-J5tg3nm2pEemEZcIpObcxH+G4ByzvUtoSyy92CcWr6M=";
  };

  vendorHash = "sha256-ywHTIuiZaoY3p7hTsnImcCpuwMXHQZcnRsWerIlOU4o=";

  subPackages = [ "cmd/livekit-cli" ];

  meta = with lib; {
    description = "Command line interface to LiveKit";
    homepage = "https://livekit.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mgdelacroix ];
    mainProgram = "livekit-cli";
  };
}
