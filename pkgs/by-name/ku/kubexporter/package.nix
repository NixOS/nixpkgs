{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubexporter";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "bakito";
    repo = "kubexporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GSM4sO28RpCSAJRhhntkqD3RrMyZ1zEaEVeWFTqArAE=";
  };

  vendorHash = "sha256-+2wzD7V6De8wd8W+ML+Lr7A8bzpxVExPDg6uuvTh/zE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/bakito/kubexporter/version.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for exporting Kubernetes resources as YAML or JSON files";
    homepage = "https://github.com/bakito/kubexporter";
    changelog = "https://github.com/bakito/kubexporter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bakito ];
    mainProgram = "kubexporter";
  };
})
