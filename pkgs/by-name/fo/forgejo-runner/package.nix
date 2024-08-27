{ lib
, buildGoModule
, fetchFromGitea
, testers
, forgejo-runner
, nixosTests
}:

buildGoModule rec {
  pname = "forgejo-runner";
  version = "3.5.1";

  src = fetchFromGitea {
    domain = "code.forgejo.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${version}";
    hash = "sha256-LRMkwSrBU5/IPXMhRT05pE487nmSffXvmfbwBiqpyj8=";
  };

  vendorHash = "sha256-XLDtWYFHwBqbkzj4yRyr3uC1FnpS0bn1ia8i6m+CTBM=";

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
    description = "A runner for Forgejo based on act";
    homepage = "https://code.forgejo.org/forgejo/runner";
    changelog = "https://code.forgejo.org/forgejo/runner/src/tag/${src.rev}/RELEASE-NOTES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes emilylange ];
    mainProgram = "act_runner";
  };
}
