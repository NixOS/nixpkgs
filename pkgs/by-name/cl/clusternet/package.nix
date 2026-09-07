{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "clusternet";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "clusternet";
    repo = "clusternet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nrnk3Ru4DTOagc7iTC4ZGyYhqhQwLIgs3fu67l0stEs=";
  };

  vendorHash = "sha256-mMXtiCz4Y5pL77c24RnZ2Uoq5Fh2pkrkApAdkd/xyyw=";

  ldFlags = [
    "-s"
    "-w"
  ];

  # Clusternet hub is disabled due to panic: inlined function github.com/clusternet/clusternet/pkg/hub/apiserver/shadow.(*crdHandler).addStorage.func9.1 missing func info
  subPackages = [
    "cmd/clusternet-agent"
    "cmd/clusternet-controller-manager"
    "cmd/clusternet-scheduler"
  ];

  meta = {
    description = "CNCF Sandbox Project for managing your Kubernetes clusters";
    homepage = "https://github.com/clusternet/clusternet";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
  };
})
