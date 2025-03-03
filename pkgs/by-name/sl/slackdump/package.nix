{
  buildGoModule,
  lib,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

buildGoModule rec {
  pname = "slackdump";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "rusq";
    repo = "slackdump";
    rev = "refs/tags/v${version}";
    hash = "sha256-hdSsvV1mQet61pWeo5icDhFxAVNP5QU1fdb1YgyXVWU=";
  };

  nativeCheckInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.IOKitTools;

  checkFlags =
    let
      skippedTests = [
        "TestSession_saveUserCache"
        "TestSession_GetUsers"
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  vendorHash = "sha256-LjZP00YL0Coc7yY0Bm7AaYoAP37vQVJpVYPxuEnVEp4=";

  meta = {
    homepage = "https://github.com/rusq/slackdump";
    changelog = "https://github.com/rusq/slackdump/releases/tag/v${version}";
    description = "Tools for saving Slack's data without admin privileges";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "slackdump";
    license = lib.licenses.gpl3Plus;
  };
}
