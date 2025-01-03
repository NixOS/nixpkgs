{
  buildGoModule,
  lib,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

buildGoModule rec {
  pname = "slackdump";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "rusq";
    repo = "slackdump";
    rev = "refs/tags/v${version}";
    hash = "sha256-szo5n1sVv9PZUW77k/1qLuU0URl0FNB4cO5vqokoZ2c=";
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

  vendorHash = "sha256-aDLeYi4nsMKxtE59au6I3mSEY0/6Vo0ujWFbLca+0wQ=";

  meta = {
    homepage = "https://github.com/rusq/slackdump";
    changelog = "https://github.com/rusq/slackdump/releases/tag/v${version}";
    description = "Tools for saving Slack's data without admin privileges";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "slackdump";
    license = lib.licenses.gpl3Plus;
  };
}
