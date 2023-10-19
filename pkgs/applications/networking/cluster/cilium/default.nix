{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "cilium-cli";
  version = "0.15.10";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iIv4xOqggbMDvscnaaz0QXjeScJ4SzOP0fvfshq+vyE=";
  };

  vendorHash = null;

  subPackages = [ "cmd/cilium" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/cilium/cilium-cli/cli.Version=${version}"
  ];

  # Required to workaround install check error:
  # 2022/06/25 10:36:22 Unable to start gops: mkdir /homeless-shelter: permission denied
  HOME = "$TMPDIR";

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/cilium version | grep ${version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd cilium \
      --bash <($out/bin/cilium completion bash) \
      --fish <($out/bin/cilium completion fish) \
      --zsh <($out/bin/cilium completion zsh)
  '';

  meta = with lib; {
    description = "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium";
    license = licenses.asl20;
    homepage = "https://www.cilium.io/";
    maintainers = with maintainers; [ humancalico bryanasdev000 qjoly ];
    mainProgram = "cilium";
  };
}
