{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "azurehound";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "SpecterOps";
    repo = "AzureHound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+3h9/R909/Bkxq0Y7oN0xpE6OH8+0Xvs/8X1NBQFrMg=";
  };

  vendorHash = "sha256-QCZFIDUL/RbSMrDfQ8L0A6xJPcWJorBXvHhdIA1WK4Q=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/bloodhoundad/azurehound/v2/constants.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  meta = {
    description = "Azure Data Exporter for BloodHound";
    homepage = "https://github.com/SpecterOps/AzureHound";
    changelog = "https://github.com/SpecterOps/AzureHound/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "azurehound";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
