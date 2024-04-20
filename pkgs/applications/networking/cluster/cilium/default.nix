{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "cilium-cli";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fhTjYhRCtJu18AGYF6hiTdRMEdlNO+DmDwh2hZBXzPk=";
  };

  vendorHash = null;

  subPackages = [ "cmd/cilium" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/cilium/cilium-cli/defaults.CLIVersion=${version}"
  ];

  # Required to workaround install check error:
  # 2022/06/25 10:36:22 Unable to start gops: mkdir /homeless-shelter: permission denied
  HOME = "$TMPDIR";

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/cilium version --client | grep ${version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd cilium \
      --bash <($out/bin/cilium completion bash) \
      --fish <($out/bin/cilium completion fish) \
      --zsh <($out/bin/cilium completion zsh)
  '';

  meta = {
    changelog = "https://github.com/cilium/cilium-cli/releases/tag/v${version}";
    description = "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium";
    license = lib.licenses.asl20;
    homepage = "https://www.cilium.io/";
    maintainers = with lib.maintainers; [ bryanasdev000 humancalico qjoly superherointj ];
    mainProgram = "cilium";
  };
}
