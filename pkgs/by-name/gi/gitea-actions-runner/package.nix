{
  lib,
  fetchFromGitea,
  buildGoModule,
  testers,
  gitea-actions-runner,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gitea-actions-runner";
  version = "6.0.1";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V84K5zC+i9I64fwUXG05oL7oyH1+C56ZFfFMPY1yf20=";
  };

  vendorHash = "sha256-HSjcmksxTmRaEHB1rRTCJHZ2VhS/+e2d7/fIXDkd9J8=";

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
