{
  lib,
  buildGoModule,
  fetchFromGitHub,
  coreutils,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "skeema";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "skeema";
    repo = "skeema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b4j7JNsAc2AdV6S6e06ioUxjFl2mcKvX3pQ7Mji5eUo=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

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
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Declarative pure-SQL schema management for MySQL and MariaDB";
    homepage = "https://skeema.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "skeema";
  };
})
