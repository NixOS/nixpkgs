{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "api-linter";
  version = "1.67.2";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    rev = "v${version}";
    hash = "sha256-xwRpJKAkZFSpmAQti2EswM6RXlJVwD+nNY9t5oRzU1s=";
  };

  vendorHash = "sha256-+dyoWK5iXH480c+akg26BCF/J8lKQoATVqZUfqMa080=";

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
