{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-view-secret";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "elsesiy";
    repo = "kubectl-view-secret";
    rev = "v${finalAttrs.version}";
    hash = "sha256-U030TzoYoSjJpohv/yeR8MVrpfIwO578I/KCIPxBj5k=";
  };

  vendorHash = "sha256-EiSqk957zurwlL0qhvRAHKQCVpmmZhDFbdplWfRg2Ec=";

  subPackages = [ "./cmd/" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubectl-view_secret
  '';

  meta = {
    description = "Kubernetes CLI plugin to decode Kubernetes secrets";
    mainProgram = "kubectl-view_secret";
    homepage = "https://github.com/elsesiy/kubectl-view-secret";
    changelog = "https://github.com/elsesiy/kubectl-view-secret/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sagikazarmark ];
  };
})
