{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "aztfexport";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "aztfexport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-97lahgEsth2YUeqTe8J58brykpFV0lG6KwB7FJgODAE=";
  };

  vendorHash = "sha256-4u40PdRT3E+BZ8bIrnIgRnJkpws6EPK5DRyXu9oY7hc=";

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
