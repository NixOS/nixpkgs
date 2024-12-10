{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "kubecfg";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${version}";
    hash = "sha256-/xfZcykOGYOnCkKQDUJ9k4xh+bwrDmy2iSNFPVLkjew=";
  };

  vendorHash = "sha256-K2IyljE5QS/SZ6EXV42q/a5ru+0UXZ69oLNi94XKxw4=";

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
    description = "Tool for managing Kubernetes resources as code";
    mainProgram = "kubecfg";
    homepage = "https://github.com/kubecfg/kubecfg";
    changelog = "https://github.com/kubecfg/kubecfg/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      benley
      qjoly
    ];
  };
}
