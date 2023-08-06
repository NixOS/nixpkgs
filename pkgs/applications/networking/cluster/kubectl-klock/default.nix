{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-klock";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "jilleJr";
    repo = "kubectl-klock";
    rev = "v${version}";
    hash = "sha256-zOdi2QUVvRPPiI22bm7Z5OeShslysjcnvkhroOjbZrU=";
  };

  vendorHash = "sha256-r4oAmD/7CXYiWEWR/FC/Ab0LNxehWv6oCWjQ/fGU2rU=";

  meta = with lib; {
    description = "A kubectl plugin to render the kubectl get pods --watch output in a much more readable fashion.";
    homepage = "https://github.com/jilleJr/kubectl-klock";
    changelog = "https://github.com/jilleJr/kubectl-klock/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.koralowiec ];
  };
}
