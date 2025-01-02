{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  plow,
}:

buildGoModule rec {
  pname = "plow";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "six-ddc";
    repo = "plow";
    rev = "refs/tags/v${version}";
    hash = "sha256-q9k5GzhYPOP8p8VKrqpoHc3B9Qak+4DtZAZZuFlkED0=";
  };

  vendorHash = "sha256-KfnDJI6M6tzfoI7krKId5FXUw27eV6cEoz3UaNrlXWk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = plow;
  };

  meta = with lib; {
    description = "High-performance HTTP benchmarking tool that includes a real-time web UI and terminal display";
    homepage = "https://github.com/six-ddc/plow";
    changelog = "https://github.com/six-ddc/plow/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ecklf ];
    mainProgram = "plow";
  };
}
