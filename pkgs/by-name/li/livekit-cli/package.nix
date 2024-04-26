{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "livekit-cli";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    rev = "v${version}";
    hash = "sha256-6UIMyroZpylUMG7TIBOqDIDsuJLtpe2BQxfjEhbZBGc=";
  };

  vendorHash = "sha256-e84jusaQx6B5cbJoIOSVyxgAQx9VIxFODH1Io1Z/yj0=";

  subPackages = [ "cmd/livekit-cli" ];

  meta = with lib; {
    description = "Command line interface to LiveKit";
    homepage = "https://livekit.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mgdelacroix ];
    mainProgram = "livekit-cli";
  };
}
