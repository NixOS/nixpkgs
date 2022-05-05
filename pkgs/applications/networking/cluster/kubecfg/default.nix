{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubecfg";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "sha256-ekojX7gl8wC7GlHG3Y+dwry7jxjIm5dbS7cNN1xu4kY=";
  };

  vendorSha256 = "sha256-dPdF3qTrYRbKUepgo6WVIVyGnaWxhQ0371fzXlBD8rE=";

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
