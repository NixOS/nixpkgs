{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "azurehound";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "SpecterOps";
    repo = "AzureHound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ny+yShWpL2OvZ5m1uehQADwj1oKPAt+/fefsztiaNVs=";
  };

  vendorHash = "sha256-buRaFYHQwaqVRig+94rLJ0rCSDV2ohb9HNUPxyIIq1g=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-X=github.com/SpecterOps/AzureHound/v2/constants/misc.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mv $out/bin/AzureHound $out/bin/$pname
  '';

  # flaky: races a 5ms sleep against a 5ms batch timeout
  checkFlags = [ "-skip=^TestBatch$" ];

  doInstallCheck = false;

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
