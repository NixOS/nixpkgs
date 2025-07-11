{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "bitrise";
  version = "2.31.3";

  src = fetchFromGitHub {
    owner = "bitrise-io";
    repo = "bitrise";
    rev = "v${version}";
    hash = "sha256-uy2B2tjtg6/ufMWy9sPoheSw2hxIsl2gUdAKVfixpoM=";
  };

  preCheck = ''
    export HOME=$TMPDIR
    rm cli/run_test.go # these are all integration tests, depending on network access
  '';

  checkFlags =
    let
      skippedTests = [
        "TestParseAndValidatePluginFromYML" # looking for `bitrise` in $PATH
        "TestDownloadPluginBin" # network access
        "TestClonePluginSrc" # network access
        "TestStepmanJSONStepLibStepInfo" # network access
        "TestMoveFileDifferentDevices" # macOS: requires /usr/bin/hdiutil
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  vendorHash = null;
  ldflags = [
    "-X github.com/bitrise-io/bitrise/version.Commit=${src.rev}"
    "-X github.com/bitrise-io/bitrise/version.BuildNumber=0"
  ];
  env.CGO_ENABLED = 0;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/bitrise-io/bitrise/releases/tag/${src.rev}";
    description = "Bitrise runner CLI - run your automations on your Mac or Linux machine";
    homepage = "https://bitrise.io";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "bitrise";
    maintainers = with lib.maintainers; [ ofalvai ];
  };
}
