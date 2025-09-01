{
  lib,
  fetchFromGitea,
  buildGoModule,
  testers,
  gitea-actions-runner,
}:

buildGoModule (finalAttrs: {
  pname = "gitea-actions-runner";
  version = "0.2.12";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z/wEs110Y2IZ2Jm6bayxlD2sjyl2V/v+gP6l9pwGi5o=";
  };

  vendorHash = "sha256-HuiL6OLShSeGtHb4dOeOFOpOgl55s3x18uYgM4X8G7M=";

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
