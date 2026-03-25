{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-tree";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = "kubectl-tree";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vk134/zetBYzsN+cfEfAzsDl6QNKOAVmpzIa9ZtpMt8=";
  };

  vendorHash = "sha256-GJQZLES0CDaA0OBp1LNKDcIWd8V49b5YFuLcubIpnDQ=";

  meta = {
    description = "kubectl plugin to browse Kubernetes object hierarchies as a tree";
    mainProgram = "kubectl-tree";
    homepage = "https://github.com/ahmetb/kubectl-tree";
    changelog = "https://github.com/ahmetb/kubectl-tree/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
  };
})
