{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubecfg";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${version}";
    hash = "sha256-5IaF7q9Ue+tHkThxYgpkrnEH7xpKBx6cqKf2Zw2mjN4=";
  };

  vendorHash = "sha256-Fh8QlXZ7I3XORjRhf5DIQmqA35LmgWVTN+iZDGaYHD8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd kubecfg \
      --bash <($out/bin/kubecfg completion --shell=bash) \
      --zsh  <($out/bin/kubecfg completion --shell=zsh)
  '';

  meta = with lib; {
    description = "A tool for managing Kubernetes resources as code";
    homepage = "https://github.com/kubecfg/kubecfg";
    changelog = "https://github.com/kubecfg/kubecfg/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
