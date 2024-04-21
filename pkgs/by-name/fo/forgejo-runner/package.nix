{ lib
, buildGoModule
, fetchFromGitea
, testers
, forgejo-runner
}:

buildGoModule rec {
  pname = "forgejo-runner";
  version = "3.4.1";

  src = fetchFromGitea {
    domain = "code.forgejo.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${version}";
    hash = "sha256-c8heIHt+EJ6LnZT4/6TTWd7v85VRHjH72bdje12un4M=";
  };

  vendorHash = "sha256-FCCQZdAYRtJR3DGQIEvUzv+1kqvxVTGkwJwZSohq28s=";

  ldflags = [
    "-s"
    "-w"
    "-X gitea.com/gitea/act_runner/internal/pkg/ver.version=${src.rev}"
  ];

  doCheck = false; # Test try to lookup code.forgejo.org.

  passthru.tests.version = testers.testVersion {
    package = forgejo-runner;
    version = src.rev;
  };

  meta = with lib; {
    description = "A runner for Forgejo based on act";
    homepage = "https://code.forgejo.org/forgejo/runner";
    changelog = "https://code.forgejo.org/forgejo/runner/src/tag/${src.rev}/RELEASE-NOTES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes emilylange ];
    mainProgram = "act_runner";
  };
}
