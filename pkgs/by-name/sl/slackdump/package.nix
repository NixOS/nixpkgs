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
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "rusq";
    repo = "slackdump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k8NY9K57gRNLjST4alD9W0UNPK/PKI6CLGvJquj1Hko=";
  };

  nativeCheckInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.IOKitTools;

  checkFlags =
    let
      skippedTests = [
        "TestSession_saveUserCache"
        "TestSession_GetUsers"
        "Test_exportV3" # This was skipped on upstream's CI. It is seemed that some file are missed
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  vendorHash = "sha256-N5NzmnpKJ8cIvaY9h6kW9dT/L7a057H+nE0gBozwsuc=";

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
