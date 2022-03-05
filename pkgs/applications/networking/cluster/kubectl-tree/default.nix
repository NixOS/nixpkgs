{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-tree";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5+INUr7ewSJrFwdhDgdrRu+xDB3FkWRjWbbVJO8cgkc=";
  };

  vendorSha256 = "sha256-/GLzIoFHXpTmY2601zA83tB2V2XS0rWy1bEDQ6P6D8k=";

  meta = with lib; {
    description = "kubectl plugin to browse Kubernetes object hierarchies as a tree";
    homepage = "https://github.com/ahmetb/kubectl-tree";
    changelog = "https://github.com/ahmetb/kubectl-tree/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
