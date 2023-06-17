{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-view-secret";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "elsesiy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+0uHBzT8cocuDttkvNHnmy/WQ+mfVIc0J0fkhBf4PLI=";
  };

  vendorSha256 = "sha256-A3bB4L4O7j6lnP3c4mF4zVY/fDac6OBM5uKJuCnZR9g=";

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
