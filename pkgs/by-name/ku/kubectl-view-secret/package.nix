{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-view-secret";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "elsesiy";
    repo = "kubectl-view-secret";
    rev = "v${version}";
    hash = "sha256-l7pyS3eQDETrGCN7+Q0xhm+9Ocpk+qxTNMu4SMq+IDU=";
  };

  vendorHash = "sha256-XtQkAgmnXNKHHjFtZN8Ht/C/aH2mPOeHk7azihehzsc=";

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
