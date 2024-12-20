{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mx-takeover";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "musana";
    repo = "mx-takeover";
    rev = "refs/tags/v${version}";
    hash = "sha256-yDQd2FEVFFsUu3wKxp26VDhGjnuXmAtxpWoKjV6ZrHA=";
  };

  vendorHash = "sha256-mJ8pVsgRM6lhEa8jtCxFhavkf7XFlBqEN9l1r0/GTvM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to work with DNS MX records";
    mainProgram = "mx-takeover";
    homepage = "https://github.com/musana/mx-takeover";
    changelog = "https://github.com/musana/mx-takeover/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
