{
  buildGoModule,
  lib,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

buildGoModule rec {
  pname = "slackdump";
  version = "2.5.11";

  src = fetchFromGitHub {
    owner = "rusq";
    repo = "slackdump";
    rev = "refs/tags/v${version}";
    hash = "sha256-othSIR+KyekUt+/LWhaM5Y6LGsujDCZTfLJotTcPXc0=";
  };

  checkFlags =
    let
      skippedTests = [
        "TestSession_saveUserCache"
        "TestSession_loadUserCache"
        "TestSession_GetUsers"
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      IOKitTools
    ]
  );

  vendorHash = "sha256-6GVXzaJ5Lrt4fF0c9cbx6AqpgCwlYgKf6jUJkUyxc0s=";

  meta = {
    homepage = "https://github.com/rusq/slackdump";
    changelog = "https://github.com/rusq/slackdump/releases/tag/v${version}";
    description = "Tools for saving Slack's data without admin privileges";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "slackdump";
    license = lib.licenses.gpl3Plus;
  };
}
