{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "api-linter";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    tag = "v${version}";
    hash = "sha256-psyv/J1/7H8s34qqZD4s7Ls1mn2lht5VbNxZrXPC0iw=";
  };

  vendorHash = "sha256-IpL9RIhO9ivXKHczca4m6R6jmcNEn5KXqNxWmtU30qE=";

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
