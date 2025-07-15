{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  pgweb,
  nixosTests,
}:

buildGoModule rec {
  pname = "pgweb";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "sosedoff";
    repo = "pgweb";
    rev = "v${version}";
    hash = "sha256-gZK8+H3dBMzSVyE96E7byihKMR4+1YlVFZJtCTGUZwI=";
  };

  postPatch = ''
    # Disable tests require network access.
    rm -f pkg/client/{client,dump}_test.go
  '';

  vendorHash = "sha256-Jpvf6cST3kBvYzCQLoJ1fijUC/hP1ouptd2bQZ1J/Lo=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        # There is a `/tmp/foo` file on the test machine causing the test case to fail on macOS
        "TestParseOptions"
      ];
    in
    [
      "-skip"
      "${builtins.concatStringsSep "|" skippedTests}"
    ];

  passthru.tests = {
    version = testers.testVersion {
      version = "v${version}";
      package = pgweb;
      command = "pgweb --version";
    };
    integration_test = nixosTests.pgweb;
  };

  meta = {
    changelog = "https://github.com/sosedoff/pgweb/releases/tag/v${version}";
    description = "Web-based database browser for PostgreSQL";
    longDescription = ''
      A simple postgres browser that runs as a web server. You can view data,
      run queries and examine tables and indexes.
    '';
    homepage = "https://sosedoff.github.io/pgweb/";
    license = lib.licenses.mit;
    mainProgram = "pgweb";
    maintainers = with lib.maintainers; [
      zupo
      luisnquin
    ];
  };
}
