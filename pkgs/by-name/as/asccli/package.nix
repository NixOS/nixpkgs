{
  buildGoModule,
  fetchFromGitHub,
  git,
  lib,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "asccli";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "rorkai";
    repo = "App-Store-Connect-CLI";
    tag = "${finalAttrs.version}";
    hash = "sha256-VMLLziuLV7F95mTdEmaUxwMC9vKSTejJZgw3KFHr7sg=";
  };

  vendorHash = "sha256-XBEDMUGwSh8P+dVKMebN3zD83e1odAN+Wy15yys0+2M=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
    "-X main.date=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    mv $out/bin/App-Store-Connect-CLI $out/bin/asc
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;
  nativeCheckInputs = [ git ];
  preCheck = ''
    export ASC_BYPASS_KEYCHAIN=1
  '';
  checkFlags =
    let
      skippedTests = [
        "TestDefaultRunSkillsCheckCommand_UsesSkillsBinaryCheckCommand"
        "TestDefaultRunSkillsCheckCommand_FallsBackToNpxOffline"
        "TestDefaultRunSkillsCheckCommand_OfflineCacheMissIsUnavailable"
        "TestAuthLogoutCommand"
        "TestAuthStatusInvalidBypassWarningPrintedOnce"
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  meta = {
    description = "Scriptable CLI for the App Store Connect API";
    homepage = "https://asccli.sh";
    changelog = "https://github.com/rorkai/App-Store-Connect-CLI/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      DimitarNestorov
    ];
    mainProgram = "asc";
  };
})
