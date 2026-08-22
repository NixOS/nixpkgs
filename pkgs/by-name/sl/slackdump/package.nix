{
  buildGoModule,
  lib,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  darwin,
}:

buildGoModule (finalAttrs: {
  pname = "slackdump";
  version = "4.4.4";

  src = fetchFromGitHub {
    owner = "rusq";
    repo = "slackdump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sEKWgl61ps2bRYBEG97NICYMGuE+6R7W+MR6vTgTE1U=";
  };

  nativeCheckInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.IOKitTools;

  checkFlags =
    let
      skippedTests = [
        "TestSession_saveUserCache"
        "TestSession_GetUsers"
        "Test_exportV3" # This was skipped on upstream's CI. It is seemed that some file are missed
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "TestWithRetry" # flaky timing-sensitive test on darwin
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  vendorHash = "sha256-MDJ0WFuOiwFlDUuC0eF7ymEcWy/7qZykHIro5mJspYY=";

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/rusq/slackdump";
    changelog = "https://github.com/rusq/slackdump/releases/tag/v${finalAttrs.version}";
    description = "Tools for saving Slack's data without admin privileges";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "slackdump";
    license = lib.licenses.gpl3Plus;
  };
})
