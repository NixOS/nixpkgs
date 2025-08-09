{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "azurehound";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "SpecterOps";
    repo = "AzureHound";
    tag = "v${version}";
    hash = "sha256-gyXra6MIDVDNA9ls5KLctSkG42vE6FkE/ILOipOoBzw=";
  };

  vendorHash = "sha256-Z8mF1etDiB8lavprf5Xpqk3cV41ezexWc/uZuu50DoA=";

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
    broken = stdenv.hostPlatform.isDarwin;
  };
}
