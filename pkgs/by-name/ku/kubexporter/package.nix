{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubexporter";
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "bakito";
    repo = "kubexporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2qScXitvdPiMBsisI4J3Z78/RJzJBPhq2hxGQe+pE9E=";
  };

  vendorHash = "sha256-1bU1jazCcx9lJf7RUewRzlvz+glPq86eOi4YVSx0au4=";

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
