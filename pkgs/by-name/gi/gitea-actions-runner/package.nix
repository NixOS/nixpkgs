{
  lib,
  fetchFromGitea,
  buildGoModule,
  testers,
  gitea-actions-runner,
}:

buildGoModule (finalAttrs: {
  pname = "gitea-actions-runner";
  version = "1.0.3";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-p6NdkQiZiEeuQjJp3CKTayStZlyk3d1XGigSI5uuLp0=";
  };

  vendorHash = "sha256-T1T5ZpGqGmipIkTWlYxlsLdAthW8bhcAvr0xyZ74+wQ=";

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

  passthru.tests.version = testers.testVersion {
    package = gitea-actions-runner;
    version = "v${finalAttrs.version}";
  };

  meta = {
    changelog = "https://gitea.com/gitea/runner/releases/tag/v${finalAttrs.version}";
    description = "Runner for Gitea based on act";
    homepage = "https://gitea.com/gitea/runner";
    license = lib.licenses.mit;
    mainProgram = "gitea-runner";
    maintainers = with lib.maintainers; [
      superherointj
      techknowlogick
    ];
  };
})
