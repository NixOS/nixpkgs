{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-view-secret";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "elsesiy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mdooeKlwoPxiAHaOuhMF+Zx1l0uZ1OYMgDADI7JbYDc=";
  };

  vendorHash = "sha256-5mSS7UWfdk28oXk/ONnnjj4OMGJAtH26xGES4NGZuTc=";

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
