{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "azurehound";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "SpecterOps";
    repo = "AzureHound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hvSnm7+xyar7E1yf2Fi6JlYU8dlgO3M+Z510VBYgHIA=";
  };

  vendorHash = "sha256-+iNFWKFNON4HX2mf4O29zAdElEkIGIx55Wi9MRtg1dg=";

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
