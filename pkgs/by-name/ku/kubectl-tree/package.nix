{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-tree";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = "kubectl-tree";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Ti2RWGNjCgaf02c2PXHL4Uml8Nws9gICwbrKcWmQ9pE=";
  };

  vendorHash = "sha256-34mxaCX5Em6/SiIrUDvTG9ZvWCzVUURk0SH+oQuOvlA=";

  meta = {
    description = "kubectl plugin to browse Kubernetes object hierarchies as a tree";
    mainProgram = "kubectl-tree";
    homepage = "https://github.com/ahmetb/kubectl-tree";
    changelog = "https://github.com/ahmetb/kubectl-tree/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
  };
})
