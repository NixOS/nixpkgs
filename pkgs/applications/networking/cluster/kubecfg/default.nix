{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubecfg";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "sha256-IJ/QKqGhhJfqRBVKfmV4jTC2C53DmzmK5AECJg2xdmw=";
  };

  vendorSha256 = "sha256-kmUhcHZ6LcxtuuucOwcO6TNk2TsWL6lcppD6M6unY2M=";

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
