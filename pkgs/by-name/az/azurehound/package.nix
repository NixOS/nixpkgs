{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "azurehound";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "SpecterOps";
    repo = "AzureHound";
    tag = "v${version}";
    hash = "sha256-12ae0y3hjeNPwB33J+XP26h+JfFN5M8+bF8CSon1jp4=";
  };

  vendorHash = "sha256-FG3207OTzkMEoSvQsTH7Ky9T3ur7glG7k0ERfd12SO0=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/bloodhoundad/azurehound/v2/constants.Version=${version}"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  meta = {
    description = "Azure Data Exporter for BloodHound";
    homepage = "https://github.com/SpecterOps/AzureHound";
    changelog = "https://github.com/SpecterOps/AzureHound/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "azurehound";
  };
}
