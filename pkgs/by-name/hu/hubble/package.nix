{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo124Module rec {
  pname = "hubble";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZrLb2dITQPd9g4azlidpTHFWNwop0AMKEIzwMX1Y7Jw=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cilium/cilium/hubble/pkg.GitBranch=none"
    "-X github.com/cilium/cilium/hubble/pkg.GitHash=none"
    "-X github.com/cilium/cilium/hubble/pkg.Version=${version}"
  ];

  # Test fails at Test_getFlowsRequestWithInvalidRawFilters in github.com/cilium/hubble/cmd/observe
  # https://github.com/NixOS/nixpkgs/issues/178976
  # https://github.com/cilium/hubble/pull/656
  # https://github.com/cilium/hubble/pull/655
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/hubble version | grep ${version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd hubble \
      --bash <($out/bin/hubble completion bash) \
      --fish <($out/bin/hubble completion fish) \
      --zsh <($out/bin/hubble completion zsh)
  '';

  meta = with lib; {
    description = "Network, Service & Security Observability for Kubernetes using eBPF";
    mainProgram = "hubble";
    license = licenses.asl20;
    homepage = "https://github.com/cilium/hubble/";
    maintainers = with maintainers; [
      humancalico
      bryanasdev000
      FKouhai
    ];
  };
}
