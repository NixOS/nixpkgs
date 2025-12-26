{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "api-linter";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    tag = "v${version}";
    hash = "sha256-oaSWp1FmanCWMRYk3Dm1WZ+MnxooXqT9rom25JeFrTg=";
  };

  vendorHash = "sha256-X5/UH8dX89nTPlYMbVuyG82WrDmU/dP7LiZfMoN6c4A=";

  subPackages = [ "cmd/api-linter" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Linter for APIs defined in protocol buffers";
    homepage = "https://github.com/googleapis/api-linter/";
    changelog = "https://github.com/googleapis/api-linter/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xrelkd ];
    mainProgram = "api-linter";
  };
}
