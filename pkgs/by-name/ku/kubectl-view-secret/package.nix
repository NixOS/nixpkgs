{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-view-secret";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "elsesiy";
    repo = "kubectl-view-secret";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EiazHsK3bljHnT4WVQBPa9Ps0/Db4xCZr+QYW0gCgsE=";
  };

  vendorHash = "sha256-ZlSqZSFSChdaGv/dkTBp4gzI30mSsTVkIKPpMqc5Gmo=";

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
