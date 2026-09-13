{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "azurehound";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "SpecterOps";
    repo = "AzureHound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zjuwz9DNqRLcFe0bnm7LIfdqkO5GxzyZvM2RAL3qRks=";
  };

  vendorHash = "sha256-/5gVm4OAI94bg1QymXbN7O3r418y2F/pUgeZnz3UEbo=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-X=github.com/SpecterOps/AzureHound/v${(lib.versions.major finalAttrs.version)}/constants.Version=${finalAttrs.version}"
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
