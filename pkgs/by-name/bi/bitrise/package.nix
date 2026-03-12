{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "bitrise";
  version = "2.39.2";

  src = fetchFromGitHub {
    owner = "bitrise-io";
    repo = "bitrise";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yduH5UkBwcp41pCeFyoOYtaTwvINrbMaQQlvmeRAXCY=";
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

  # resolves error: main module (github.com/bitrise-io/bitrise/v2) does not contain package github.com/bitrise-io/bitrise/v2/integrationtests/config
  excludedPackages = [
    "./integrationtests"
  ];

  vendorHash = null;
  ldflags = [
    "-X github.com/bitrise-io/bitrise/version.Commit=${finalAttrs.src.rev}"
    "-X github.com/bitrise-io/bitrise/version.BuildNumber=0"
  ];
  env.CGO_ENABLED = 0;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/bitrise-io/bitrise/releases";
    description = "CLI for running your Workflows from Bitrise on your local machine";
    homepage = "https://bitrise.io/cli";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "bitrise";
    maintainers = with lib.maintainers; [ ofalvai ];
  };
})
