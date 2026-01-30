{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "aztfexport";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "aztfexport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j6WdQvbxmHOMEfCvnFDxr9ZNOZg0BIOC6u1nw+n3hA0=";
  };

  vendorHash = "sha256-qb4/sUjtfw/USITTLSuB2fXWR2mAuAcvbawrNA/ilRo=";

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
