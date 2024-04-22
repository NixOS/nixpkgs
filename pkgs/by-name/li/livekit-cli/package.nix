{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "livekit-cli";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    rev = "v${version}";
    hash = "sha256-/H7Xn/nUumKf62qV6kt2PBbvIt67IwA1dt+hj8mbE30=";
  };

  vendorHash = "sha256-yO2Qr6H5sZGLMHiue5IVHkF1IDsZZh48s6KNpXR+nzA=";

  subPackages = [ "cmd/livekit-cli" ];

  meta = with lib; {
    description = "Command line interface to LiveKit";
    homepage = "https://livekit.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mgdelacroix ];
    mainProgram = "livekit-cli";
  };
}
