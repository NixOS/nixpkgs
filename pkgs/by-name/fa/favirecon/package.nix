{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "favirecon";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "favirecon";
    tag = "v${version}";
    hash = "sha256-fxUukhKbxxUUaOMcYxNR29H1nxRb0IWT0Qy5XJNOYjU=";
  };

  vendorHash = "sha256-Xsi4EA6wBgF7jmel38csh1T3I/SQfkMI0g1pR54nwCM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to detect technologies, WAF, exposed panels and known services";
    homepage = "https://github.com/edoardottt/favirecon";
    changelog = "https://github.com/edoardottt/favirecon/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "favirecon";
  };
}
