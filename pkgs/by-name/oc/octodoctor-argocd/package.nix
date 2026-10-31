{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "octodoctor-argocd";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "OctopusDeploy";
    repo = "octodoctor-argocd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VV9echbGGzbtfJDJ0Qdl5y4bz3dvIxdzBUdPTY/Srj8=";
  };

  vendorHash = "sha256-pEwDSRnokQMI4Ckg8tvqzvkae+AyHEfk7CkdS8YS31c=";

  __structuredAttrs = true;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/octodoctor-argocd $out/bin/octodoctor
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scan Argo CD clusters and manifests for bad practices and common issues";
    homepage = "https://github.com/OctopusDeploy/octodoctor-argocd";
    changelog = "https://github.com/OctopusDeploy/octodoctor-argocd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thatmlopsguy ];
    mainProgram = "octodoctor";
  };
})
