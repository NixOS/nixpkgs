{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "api-linter";
  version = "1.72.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    tag = "v${version}";
    hash = "sha256-RI2JBeDeB37AhCMYpZzUKl10hcLNL5uOkMwRSBCtJG0=";
  };

  vendorHash = "sha256-lILGYebnm3OkqsrXdElV1vDzyhVAk4iJGZrffKX9RTA=";

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
