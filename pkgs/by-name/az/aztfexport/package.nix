{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "aztfexport";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "aztfexport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2MK+2EFUXYdU2wfCJ4t3qP6G44vqQCL6HmxlD1sFShQ=";
  };

  vendorHash = "sha256-cbhAtX3CNJSRJTqwyI0lgRqrPuBvlqVnuLAcA73ZfXE=";

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
