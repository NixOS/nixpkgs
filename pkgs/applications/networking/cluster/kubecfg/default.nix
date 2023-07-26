{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubecfg";
  version = "0.31.4";

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${version}";
    hash = "sha256-1hjSuHGZ7NTsYLeV9Cw3wP5tUdAHRSmGlKkL54G/09U=";
  };

  vendorHash = "sha256-0cpb5thhTJ7LPOYSd4WSPnS9OTXU608nk8xX5bsAm5w=";

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
  };
}
