{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kwok";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kwok";
    rev = "refs/tags/v${version}";
    hash = "sha256-3g8enPxxh2SaxiDgDwJpAfSjv/iRoBRmTnXwDtuMdFA=";
  };

  vendorHash = "sha256-YVGXYN7PgGgBzxhx6piP3NHRAsR1/pCj97UWB21WNMg=";

  doCheck = false; # docker is need for test

  meta = {
    description = "Simulate massive Kubernetes clusters with low resource usage locally without kubelet";
    homepage = "https://kwok.sigs.k8s.io";
    changelog = "https://github.com/kubernetes-sigs/kwok/releases/tag/v${version}";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
