{
  lib,
  buildGoModule,
  fetchFromGitHub,
  coreutils,
  testers,
  skeema,
}:

buildGoModule rec {
  pname = "skeema";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "skeema";
    repo = "skeema";
    rev = "v${version}";
    hash = "sha256-XA4Bi11XstL9tqQqv7t4toQN464n1CePM51VmaUIRaE=";
  };

  vendorHash = null;

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # Fix tests expecting /usr/bin/printf and /bin/echo
    substituteInPlace skeema_cmd_test.go \
      --replace-fail /usr/bin/printf "${coreutils}/bin/printf"

    substituteInPlace internal/fs/dir_test.go \
      --replace-fail /bin/echo "${coreutils}/bin/echo" \
      --replace-fail /usr/bin/printf "${coreutils}/bin/printf"

    substituteInPlace internal/applier/ddlstatement_test.go \
      --replace-fail /bin/echo "${coreutils}/bin/echo"
  '';

  checkFlags =
    let
      skippedTests = [
        # Tests requiring network access to gitlab.com
        "TestDirRelPath"
        "TestParseDir"

        # Flaky tests
        "TestCommandTimeout"
        "TestShellOutTimeout"

        # Fails with 'internal/fs/testdata/cfgsymlinks1/validrel/.skeema is a symlink pointing outside of its repo'.
        "TestParseDirSymlinks"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.tests.version = testers.testVersion {
    package = skeema;
  };

  meta = {
    description = "Declarative pure-SQL schema management for MySQL and MariaDB";
    homepage = "https://skeema.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "skeema";
  };
}
