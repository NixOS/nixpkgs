{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubexporter";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "bakito";
    repo = "kubexporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lj9AAW51lWxUJWKi/xoyUsFjFEb4hXrTD63loNIjsXY=";
  };

  vendorHash = "sha256-M7l2NeH3mcIhcBafxWPbrC3mU2GKLB89B1aQZJi7ysI=";

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
