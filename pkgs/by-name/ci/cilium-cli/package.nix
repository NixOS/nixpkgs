{
  lib,
  buildGoModule,
  cilium-cli,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:

buildGoModule rec {
  pname = "cilium-cli";
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "cilium-cli";
    tag = "v${version}";
    hash = "sha256-2lmf0bKmlNt+axgwiNPKcaq08Bf/88sp3JEkS8dkP7M=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = null;

  subPackages = [ "cmd/cilium" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=${version}"
  ];

  # Required to workaround install check error:
  # 2022/06/25 10:36:22 Unable to start gops: mkdir /homeless-shelter: permission denied
  HOME = "$TMPDIR";

  postInstall = ''
    installShellCompletion --cmd cilium \
      --bash <($out/bin/cilium completion bash) \
      --fish <($out/bin/cilium completion fish) \
      --zsh <($out/bin/cilium completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = cilium-cli;
    command = "cilium version --client";
    version = "${version}";
  };

  meta = {
    description = "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium";
    homepage = "https://www.cilium.io/";
    changelog = "https://github.com/cilium/cilium-cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      bryanasdev000
      humancalico
      qjoly
      ryan4yin
    ];
    mainProgram = "cilium";
  };
}
