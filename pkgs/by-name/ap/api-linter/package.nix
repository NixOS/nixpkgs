{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "api-linter";
  version = "1.66.2";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    rev = "v${version}";
    hash = "sha256-W4v+/XTtKE5MLRK8eaI1oz4ZB5K+QlY467WSz+RSaH0=";
  };

  vendorHash = "sha256-czLcy/9QbBuKu3lPISx3Pzf2ccvdp7gF0SWVbSZ6Nn8=";

  subPackages = [ "cmd/api-linter" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Linter for APIs defined in protocol buffers";
    homepage = "https://github.com/googleapis/api-linter/";
    changelog = "https://github.com/googleapis/api-linter/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "api-linter";
  };
}
