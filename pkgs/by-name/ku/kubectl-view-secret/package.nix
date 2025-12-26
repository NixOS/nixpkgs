{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-view-secret";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "elsesiy";
    repo = "kubectl-view-secret";
    rev = "v${version}";
    hash = "sha256-JFVW/k+TMsIo24zBqjtpoei6YRW/rgwu0qFEHvZbc1c=";
  };

  vendorHash = "sha256-WgIDyj3zZK1scXarlVA82FP3FdJs5jSR88OBJhyeWls=";

  subPackages = [ "./cmd/" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubectl-view_secret
  '';

  meta = {
    description = "Kubernetes CLI plugin to decode Kubernetes secrets";
    mainProgram = "kubectl-view_secret";
    homepage = "https://github.com/elsesiy/kubectl-view-secret";
    changelog = "https://github.com/elsesiy/kubectl-view-secret/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sagikazarmark ];
  };
}
