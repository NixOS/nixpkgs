{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-tree";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = "kubectl-tree";
    rev = "v${version}";
    sha256 = "sha256-J4/fiTECcTE0N2E+MPrQKE9Msvvm8DLdvLbnDUnUo74=";
  };

  vendorHash = "sha256-iblEfpYOvTjd3YXQ3Mmj5XckivHoXf4336H+F7NEfBA=";

  meta = {
    description = "kubectl plugin to browse Kubernetes object hierarchies as a tree";
    mainProgram = "kubectl-tree";
    homepage = "https://github.com/ahmetb/kubectl-tree";
    changelog = "https://github.com/ahmetb/kubectl-tree/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
  };
}
