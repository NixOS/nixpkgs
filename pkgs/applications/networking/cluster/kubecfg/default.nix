{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubecfg";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${version}";
    sha256 = "sha256-5IaF7q9Ue+tHkThxYgpkrnEH7xpKBx6cqKf2Zw2mjN4=";
  };

  vendorSha256 = "sha256-Fh8QlXZ7I3XORjRhf5DIQmqA35LmgWVTN+iZDGaYHD8=";

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
