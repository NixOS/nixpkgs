{
  lib,
  fetchFromGitea,
  buildGo127Module,
  testers,
  gitea-actions-runner,
  nixosTests,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "gitea-actions-runner";
  version = "5.4.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LtKvsx3+06PfiYI/+m+mNkk4SktiAyCxhOVFvYPIjHM=";
  };

  vendorHash = "sha256-gYzgsj+3ZvRyN5G8ZY4VvXQYQidQrK7EZjMcuvrXnlk=";

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
    tests = {
      version = testers.testVersion {
        package = gitea-actions-runner;
        version = "v${finalAttrs.version}";
      };
      nixos = nixosTests.gitea-actions-runner;
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
