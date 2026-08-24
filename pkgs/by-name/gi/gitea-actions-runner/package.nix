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
  version = "3.1.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-A9Md5sG1Rswmd8vqwoVqwkNJDVdOo6QGianHnfwGHa0=";
  };

  vendorHash = "sha256-02PGO8py5vjuqhLe9wncVH5f3fOVExJEMVngc0GUR9Y=";

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
