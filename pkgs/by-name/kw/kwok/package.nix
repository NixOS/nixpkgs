{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kwok";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kwok";
    rev = "refs/tags/v${version}";
    hash = "sha256-RVyXGPT30Fz+K1VdMneYldXvzHyimuCX406DMKOtUq4=";
  };

  vendorHash = "sha256-xzFbcsL6pz91GFwjkriTMKlX2fgm2NMO9+H3lqH/C2c=";

  doCheck = false; # docker is need for test

  meta = {
    description = "Simulate massive Kubernetes clusters with low resource usage locally without kubelet";
    homepage = "https://kwok.sigs.k8s.io";
    changelog = "https://github.com/kubernetes-sigs/kwok/releases/tag/v${version}";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
