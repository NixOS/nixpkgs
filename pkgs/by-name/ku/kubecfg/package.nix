{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "kubecfg";
  version = "0.35.2";

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${version}";
    hash = "sha256-iCeeS6CVGEFrNqa0NvdV2AqViDQIfG02Hx8yOBO1Vsk=";
  };

  vendorHash = "sha256-nAjm4AotRYZGRv05A+dviNq6Moo53Zo/bOiQf972ZF8=";

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
