{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "aztfexport";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "aztfexport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wHI/osu2Jq85zCgh1HfOTuO81mYtQJcSbvlDnXd7Duc=";
  };

  vendorHash = "sha256-QDpoOlu1qGNK0ennplusXBgeQWZP3EH7aSStllP8uzw=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "Tool to bring existing Azure resources under Terraform's management";
    homepage = "https://github.com/Azure/aztfexport";
    changelog = "https://github.com/Azure/aztfexport/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.john-rodewald ];
    mainProgram = "aztfexport";
  };
})
