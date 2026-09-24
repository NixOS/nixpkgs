{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "gh-ost";
  version = "1.1.11";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-ost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zmq2KqNjFb4htk5Wl0eA4Ef0bR16jto9YVFbVESehFI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.AppVersion=${finalAttrs.version}"
  ];

  checkFlags =
    let
      # Skip tests that require docker daemon
      skippedTests = [
        "TestApplier"
        "TestEventsStreamer"
        "TestMigrator"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Triggerless online schema migration solution for MySQL";
    homepage = "https://github.com/github/gh-ost";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "gh-ost";
  };
})
