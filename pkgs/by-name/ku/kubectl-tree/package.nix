{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-tree";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = "kubectl-tree";
    rev = "v${version}";
    sha256 = "sha256-o5LfWVirp6ENYxqiUSvBDenAzeIIeio2WDD9Ll7Khgk=";
  };

  vendorHash = "sha256-8vfZDegdPUh7U1ApOYl3PgTPba5cIk4lwRo+5jTZU0s=";

  meta = {
    description = "kubectl plugin to browse Kubernetes object hierarchies as a tree";
    mainProgram = "kubectl-tree";
    homepage = "https://github.com/ahmetb/kubectl-tree";
    changelog = "https://github.com/ahmetb/kubectl-tree/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
  };
}
