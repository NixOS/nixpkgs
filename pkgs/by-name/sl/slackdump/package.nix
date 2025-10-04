{
  buildGoModule,
  lib,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  darwin,
}:

buildGoModule rec {
  pname = "slackdump";
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "rusq";
    repo = "slackdump";
    tag = "v${version}";
    hash = "sha256-rVNXVkM4DpfNdqDGzaw23zOL/VSbzKsCyOc/Cq/mtZM=";
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

  vendorHash = "sha256-XnEuxYxrkKTJcXrDFQB4tw3dCJFVwGkw8kKJm+y+ees=";

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/rusq/slackdump";
    changelog = "https://github.com/rusq/slackdump/releases/tag/v${version}";
    description = "Tools for saving Slack's data without admin privileges";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "slackdump";
    license = lib.licenses.gpl3Plus;
  };
}
