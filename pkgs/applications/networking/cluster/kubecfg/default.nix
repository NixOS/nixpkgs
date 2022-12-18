{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubecfg";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "sha256-Ask1Mbt/7xhfTNPmLIFtndT6qqbyotFrhoaUggzgGas=";
  };

  vendorSha256 = "sha256-vqlANAwZTC4goeN/KsrYL9GWzkhi4WUx9Llyi863KVY=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd kubecfg \
      --bash <($out/bin/kubecfg completion --shell=bash) \
      --zsh  <($out/bin/kubecfg completion --shell=zsh)
  '';

  meta = {
    description = "A tool for managing Kubernetes resources as code";
    homepage = "https://github.com/kubecfg/kubecfg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.unix;
  };
}
