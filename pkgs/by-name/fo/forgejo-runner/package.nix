{ lib
, buildGoModule
, fetchFromGitea
, nixosTests
, versionCheckHook
}:

buildGoModule rec {
  pname = "forgejo-runner";
  version = "3.5.0";

  src = fetchFromGitea {
    domain = "code.forgejo.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${version}";
    hash = "sha256-omp62KJVPSl3DqZxB1WJFd5secYIAc/6n6Ke5xzICQo=";
  };

  vendorHash = "sha256-FCCQZdAYRtJR3DGQIEvUzv+1kqvxVTGkwJwZSohq28s=";

  ldflags = [
    "-s"
    "-w"
    "-X gitea.com/gitea/act_runner/internal/pkg/ver.version=${src.rev}"
  ];

  doCheck = false; # Test try to lookup code.forgejo.org.

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  versionCheckProgram = "act_runner";

  passthru.tests = {
    inherit (nixosTests.forgejo) sqlite3;
  };

  meta = with lib; {
    description = "Runner for Forgejo based on act";
    homepage = "https://code.forgejo.org/forgejo/runner";
    changelog = "https://code.forgejo.org/forgejo/runner/src/tag/${src.rev}/RELEASE-NOTES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes emilylange ];
    mainProgram = "act_runner";
  };
}
