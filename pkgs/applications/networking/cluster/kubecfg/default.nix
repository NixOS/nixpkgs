{ lib, buildGoPackage, fetchFromGitHub, installShellFiles }:

buildGoPackage rec {
  pname = "kubecfg";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "bitnami";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "sha256-8U/A4F4DboS46ftpuk5fQGT2Y0V+X0y0L3/o4x8qpnY=";
  };

  goPackagePath = "github.com/bitnami/kubecfg";

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd kubecfg \
      --bash <($out/bin/kubecfg completion --shell=bash) \
      --zsh  <($out/bin/kubecfg completion --shell=zsh)
  '';

  meta = {
    description = "A tool for managing Kubernetes resources as code";
    homepage = "https://github.com/bitnami/kubecfg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.unix;
  };
}
