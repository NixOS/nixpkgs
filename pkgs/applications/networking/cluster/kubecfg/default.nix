{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubecfg";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${version}";
    hash = "sha256-UGxtL8X1wEyo7jYmPw0GTvuzzQCBA3WTIowMnYSyfvM=";
  };

  vendorHash = "sha256-AbEEHG+LJB5fOm8koVQllKohtb0lqD6Kln3GCwlkb/0=";

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
    maintainers = with maintainers; [ benley qjoly ];
  };
}
