{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "mautrix-slack";
  version = "25.10";
  tag = "v0.2510.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    tag = tag;
    hash = "sha256-PeSE7WKFSSxZyyG9TJmYeCzHY3bPvkHZ5l+mLzr8tS8=";
  };

  vendorHash = "sha256-9MsHRU2EqMTWEMVraJ/6/084X5yx3zzSdxP8zSYFJ1E=";

  tags = "goolm";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${tag}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Matrix-Slack puppeting bridge";
    homepage = "https://github.com/mautrix/slack";
    changelog = "https://github.com/mautrix/slack/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ BonusPlay ];
    mainProgram = "mautrix-slack";
  };
}
