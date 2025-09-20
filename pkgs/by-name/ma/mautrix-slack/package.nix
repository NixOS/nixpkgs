{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
let
  version = "0.2.3";
in
buildGoModule {
  pname = "mautrix-slack";
  inherit version;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    tag = "v${version}";
    hash = "sha256-gR5D2uCNS+LiP0KXup/iIiOThWohzeBe4CD/oWak1BM=";
  };

  vendorHash = "sha256-aukL6RThtWcznz/x25btTTvloYkRZ/vhAQj1hOdI1U4=";

  tags = "goolm";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

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
