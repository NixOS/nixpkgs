{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-view-secret";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "elsesiy";
    repo = "kubectl-view-secret";
    rev = "v${version}";
    hash = "sha256-MnXVPQGceVjX8IMZNyioecmczv+mx+feCP29zfmLTf0=";
  };

  vendorHash = "sha256-Qil2orjyjv2w7QbbVqVmsOW/TtCK6hHOIPtRZnL0V6k=";

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
