{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "cloud-provider-kind";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cloud-provider-kind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cepXHW5L7aqo6L1rtjvH35aMxv7CcB0Ii8Ci0FXcw5k=";
  };
  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  vendorHash = "sha256-kFcAY78xPGiRQ8a3mAdnO2OylrLi6JTtp0YCsc6jXvo=";

  checkFlags = lib.optional stdenv.hostPlatform.isDarwin "-skip=^Test_firstSuccessfulProbe$";

  meta = {
    description = "Load Balancer implementation for Kubernetes-in-Docker";
    homepage = "https://github.com/kubernetes-sigs/cloud-provider-kind";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicoo ];
    mainProgram = "cloud-provider-kind";
  };
})
