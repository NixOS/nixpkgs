{
  lib,
  buildGoModule,
  fetchFromGitea,
  testers,
  forgejo-runner,
  nixosTests,
}:

buildGoModule rec {
  pname = "forgejo-runner";
  version = "4.0.1";

  src = fetchFromGitea {
    domain = "code.forgejo.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${version}";
    hash = "sha256-hG8gCohf+U8T9A9Abqey9upErJklbCp8HuzHQKFcu3E=";
  };

  vendorHash = "sha256-yRXI9/LVj4f7qFdScqfpL5WCsK+lJXa6yQmdbUhfrKY=";

  ldflags = [
    "-s"
    "-w"
    "-X gitea.com/gitea/act_runner/internal/pkg/ver.version=${src.rev}"
  ];

  doCheck = false; # Test try to lookup code.forgejo.org.

  passthru.tests = {
    inherit (nixosTests.forgejo) sqlite3;
    version = testers.testVersion {
      package = forgejo-runner;
      version = src.rev;
    };
  };

  meta = with lib; {
    description = "Runner for Forgejo based on act";
    homepage = "https://code.forgejo.org/forgejo/runner";
    changelog = "https://code.forgejo.org/forgejo/runner/src/tag/${src.rev}/RELEASE-NOTES.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      kranzes
      emilylange
    ];
    mainProgram = "act_runner";
  };
}
