{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "misconfig-mapper";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    rev = "refs/tags/v${version}";
    hash = "sha256-TA6vnK1UAT66uPJzM4QJxjcpVZKPyAe4ZayYcrggzpc=";
  };

  vendorHash = "sha256-KN4jasuVP6WJjoqQNPhqvXcmgbj16sX//PxAloj1w20=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to uncover security misconfigurations on popular third-party services";
    homepage = "https://github.com/intigriti/misconfig-mapper";
    changelog = "https://github.com/intigriti/misconfig-mapper/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "misconfig-mapper";
  };
}
