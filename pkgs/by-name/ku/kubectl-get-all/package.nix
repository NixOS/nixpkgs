{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-get-all";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "stackitcloud";
    repo = "kubectl-get-all";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fVe9PY5MFX6Yc31dLi6C1bXZ39Em+Piq4EWoQce8srY=";
  };

  vendorHash = "sha256-ifOKYXgIZcKT1jov5cGBtH3IdZBVBqHO/JNkMlDXops=";

  ldflags = [
    "-X github.com/stackitcloud/kubectl-get-all/internal/version.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/kubectl-get-all $out/bin/kubectl-get_all
  '';

  versionCheckProgramArg = [ "version" ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Like kubectl get all, but get really all resources";
    mainProgram = "kubectl-get_all";
    homepage = "https://github.com/stackitcloud/kubectl-get-all";
    changelog = "https://github.com/stackitcloud/kubectl-get-all/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.tboerger ];
  };
})
