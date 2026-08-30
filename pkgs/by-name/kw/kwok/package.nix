{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kwok";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kwok";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SXiZiDor/+58JcKSBPHOWijvuCqdFmP2vRKJzLTriw8=";
  };

  vendorHash = "sha256-Y+tQKkuLPA4gGtlhQlG8rrvNB+n0whRKUpaqIf1WxX8=";

  doCheck = false; # docker is need for test

  meta = {
    description = "Simulate massive Kubernetes clusters with low resource usage locally without kubelet";
    homepage = "https://kwok.sigs.k8s.io";
    changelog = "https://github.com/kubernetes-sigs/kwok/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
})
