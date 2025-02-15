{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "api-linter";
  version = "1.69.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    rev = "v${version}";
    hash = "sha256-a+TBI4rm/6JzDH6PZyYfX6ThZuA6FW7H6ml5K9lorG4=";
  };

  vendorHash = "sha256-wQQGQHz7Z8iSaDbfGWR/MazCo27uLycN0rKerRqzCDc=";

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
