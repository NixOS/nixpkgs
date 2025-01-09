{
  lib,
  fetchFromGitea,
  buildGo123Module,
  testers,
  gitea-actions-runner,
}:

buildGo123Module rec {
  pname = "gitea-actions-runner";
  version = "0.2.11";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "v${version}";
    hash = "sha256-PmDa8XIe1uZ4SSrs9zh5HBmFaOuj+uuLm7jJ4O5V1dI=";
  };

  vendorHash = "sha256-lYJFySGqkhT89vHDp1FcTiiC7DG4ziQ1DaBHLh/kXQc=";

  ldflags = [
    "-s"
    "-w"
    "-X gitea.com/gitea/act_runner/internal/pkg/ver.version=v${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = gitea-actions-runner;
    version = "v${version}";
  };

  meta = with lib; {
    mainProgram = "act_runner";
    maintainers = with maintainers; [ techknowlogick ];
    license = licenses.mit;
    changelog = "https://gitea.com/gitea/act_runner/releases/tag/v${version}";
    homepage = "https://gitea.com/gitea/act_runner";
    description = "Runner for Gitea based on act";
  };
}
