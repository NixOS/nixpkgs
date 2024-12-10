{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-view-secret";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "elsesiy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5X5rOoERx6HoG3cOBpYm12anMXXDjTtHZzQOOlJeJSs=";
  };

  vendorHash = "sha256-oQvmS05nev+ypfkKAlTN+JbzPux5iAzHsojW8SxtB70=";

  subPackages = [ "./cmd/" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubectl-view-secret
  '';

  meta = with lib; {
    description = "Kubernetes CLI plugin to decode Kubernetes secrets";
    mainProgram = "kubectl-view-secret";
    homepage = "https://github.com/elsesiy/kubectl-view-secret";
    changelog = "https://github.com/elsesiy/kubectl-view-secret/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.sagikazarmark ];
  };
}
