{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  stdenv,
}:
buildGoModule rec {
  pname = "cloud-provider-kind";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cloud-provider-kind";
    tag = "v${version}";
    hash = "sha256-6HdP6/uUCtLyZ7vjFGB2NLqe73v/yolRTUE5s/KyIIk=";
  };
  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  vendorHash = null;

  checkFlags = lib.optional stdenv.hostPlatform.isDarwin "-skip=^Test_firstSuccessfulProbe$";

  meta = {
    description = "Load Balancer implementation for Kubernetes-in-Docker";
    homepage = "https://github.com/kubernetes-sigs/cloud-provider-kind";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicoo ];
    mainProgram = "cloud-provider-kind";
  };
}
