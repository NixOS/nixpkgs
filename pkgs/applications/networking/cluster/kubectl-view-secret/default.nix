{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-view-secret";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "elsesiy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IdbJQ3YCIPcp09/NORWGezqjbwktObN7TuQdq5uAN4A=";
  };

  vendorHash = "sha256-Q6OosaHDzq9a2Nt18LGiGJ1C2i1/BRYGaNEBeK0Ohiw=";

  subPackages = [ "./cmd/" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubectl-view-secret
  '';

  meta = with lib; {
    description = "Kubernetes CLI plugin to decode Kubernetes secrets";
    homepage = "https://github.com/elsesiy/kubectl-view-secret";
    changelog = "https://github.com/elsesiy/kubectl-view-secret/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.sagikazarmark ];
  };
}
