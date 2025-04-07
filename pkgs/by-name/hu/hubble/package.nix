{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGo124Module rec {
  pname = "hubble";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "hubble";
    tag = "v${version}";
    hash = "sha256-ZkowUftSEGo+UjYM+kk3tQJc8QJgoJATeIKPwu2ikQ4=";
  };

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/cilium/cilium/hubble/pkg.GitBranch=none"
    "-X=github.com/cilium/cilium/hubble/pkg.GitHash=none"
    "-X=github.com/cilium/cilium/hubble/pkg.Version=${version}"
  ];

  # Test fails at Test_getFlowsRequestWithInvalidRawFilters in github.com/cilium/hubble/cmd/observe
  # https://github.com/NixOS/nixpkgs/issues/178976
  # https://github.com/cilium/hubble/pull/656
  # https://github.com/cilium/hubble/pull/655
  doCheck = false;

  doInstallCheck = true;

  postInstall = ''
    installShellCompletion --cmd hubble \
      --bash <($out/bin/hubble completion bash) \
      --fish <($out/bin/hubble completion fish) \
      --zsh <($out/bin/hubble completion zsh)
  '';

  meta = with lib; {
    description = "Network, Service & Security Observability for Kubernetes using eBPF";
    homepage = "https://github.com/cilium/hubble/";
    changelog = "https://github.com/cilium/hubble/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      humancalico
      bryanasdev000
      FKouhai
    ];
    mainProgram = "hubble";
  };
}
