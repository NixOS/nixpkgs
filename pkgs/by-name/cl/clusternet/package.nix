{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "clusternet";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "clusternet";
    repo = "clusternet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MtiQM2msHv2gLaVpYoSrzJMZWwA0vMBIklwAQi+lG4g=";
  };

  vendorHash = "sha256-vG+k9ttXp/QqhbVKgwn2uo5kEk8OD+LBvJi5lBQfUk4=";

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
