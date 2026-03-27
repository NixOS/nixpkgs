{
  lib,
  fetchFromGitea,
  buildGoModule,
  testers,
  gitea-actions-runner,
}:

buildGoModule (finalAttrs: {
  pname = "gitea-actions-runner";
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-D2b0m3XEEEugjnrEzpYGxwD8hzpoPzIW9lNrCbgmKVc=";
  };

  vendorHash = "sha256-EqU+YJrwKtA9LHa7DkRJ6er5GNocR8Gbhjjx72mPhqE=";

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
