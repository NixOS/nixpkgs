{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hubble";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-L8sRvIA89RiXjrG0WcH72iYKlNTFvmQrveA9k5EBRKo=";
  };

  vendorSha256 = null;

  ldflags = [
    "-s" "-w"
    "-X github.com/cilium/hubble/pkg.GitBranch=none"
    "-X github.com/cilium/hubble/pkg.GitHash=none"
    "-X github.com/cilium/hubble/pkg.Version=${version}"
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
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Network, Service & Security Observability for Kubernetes using eBPF";
    license = licenses.asl20;
    homepage = "https://github.com/cilium/hubble/";
    maintainers = with maintainers; [ humancalico bryanasdev000 ];
  };
}
