{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kwok";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kwok";
    tag = "v${version}";
    hash = "sha256-gtDGkAXbNCWUVGL4+C6mOkWwrPcik6+nGEQNrjLb57U=";
  };

  vendorHash = "sha256-UNso+e/zYah0jApHZgWnQ3cUSV44HsMqPy4q4JMCyiA=";

  doCheck = false; # docker is need for test

  meta = {
    description = "Simulate massive Kubernetes clusters with low resource usage locally without kubelet";
    homepage = "https://kwok.sigs.k8s.io";
    changelog = "https://github.com/kubernetes-sigs/kwok/releases/tag/v${version}";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
