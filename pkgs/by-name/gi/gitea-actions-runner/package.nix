{
  lib,
  fetchFromGitea,
  buildGoModule,
  testers,
  gitea-actions-runner,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gitea-actions-runner";
  version = "2.1.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jkK61OZgbMDHD5yxrpyP1BWCVzDiR79dVaC5ItS99BU=";
  };

  vendorHash = "sha256-5K0vL0CDYgL/Ud7i4um3mz887Er4qmuhCd9dt5zyUHA=";

  # Tests require network access (artifactcache tests try to determine outbound IP)
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X gitea.com/gitea/runner/internal/pkg/ver.version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv "$out/bin/runner" "$out/bin/gitea-runner"
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = gitea-actions-runner;
      version = "v${finalAttrs.version}";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://gitea.com/gitea/runner/releases/tag/v${finalAttrs.version}";
    description = "Runner for Gitea based on act";
    homepage = "https://gitea.com/gitea/runner";
    license = lib.licenses.mit;
    mainProgram = "gitea-runner";
    maintainers = with lib.maintainers; [ techknowlogick ];
  };
})
