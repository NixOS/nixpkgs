{
  lib,
  fetchFromGitea,
  buildGoModule,
  testers,
  gitea-actions-runner,
}:

buildGoModule (finalAttrs: {
  pname = "gitea-actions-runner";
  version = "0.2.13";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-S0pZddExNw4RQvigWJh4r1CPDS+eOCa1n/8278J3wR4=";
  };

  vendorHash = "sha256-F+rFv0s/GBY3InWiofk3MCADfyauAmL/TpilWhZB5vE=";

  ldflags = [
    "-s"
    "-w"
    "-X gitea.com/gitea/act_runner/internal/pkg/ver.version=v${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = gitea-actions-runner;
    version = "v${finalAttrs.version}";
  };

  meta = {
    mainProgram = "act_runner";
    maintainers = with lib.maintainers; [ techknowlogick ];
    license = lib.licenses.mit;
    changelog = "https://gitea.com/gitea/act_runner/releases/tag/v${finalAttrs.version}";
    homepage = "https://gitea.com/gitea/act_runner";
    description = "Runner for Gitea based on act";
  };
})
