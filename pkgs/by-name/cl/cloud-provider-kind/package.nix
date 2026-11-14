{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  stdenv,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "cloud-provider-kind";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cloud-provider-kind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CHO9TeZxE8HEzQA7ezdn7AexO14jXyf2lwRm+mY7VLE=";
  };
  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  vendorHash = "sha256-ZqCfe4Iu0Q76DxKNMi8AXPLNAJn6iywgmXIN2F0QyZI=";

  checkFlags = lib.optional stdenv.hostPlatform.isDarwin "-skip=^Test_firstSuccessfulProbe$";

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/cloud-provider-kind/cmd.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Load Balancer implementation for Kubernetes-in-Docker";
    homepage = "https://github.com/kubernetes-sigs/cloud-provider-kind";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicoo ];
    mainProgram = "cloud-provider-kind";
  };
})
