{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "kube-bench";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "kube-bench";
    tag = "v${version}";
    hash = "sha256-5QY7rDFv6UV5qIdgKUGkb1DYZYid3POgEzPwSPKtHDU=";
  };

  vendorHash = "sha256-fmhlqPizAIVVzJAIHfY2gtCpJZY5Sx1Uih/7m7YEM98=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=v${version}"
  ];

  postInstall = ''
    mkdir -p $out/share/kube-bench/
    mv ./cfg $out/share/kube-bench/

    installShellCompletion --cmd kube-bench \
      --bash <($out/bin/kube-bench completion bash) \
      --fish <($out/bin/kube-bench completion fish) \
      --zsh <($out/bin/kube-bench completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/kube-bench --help
    $out/bin/kube-bench version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/aquasecurity/kube-bench";
    changelog = "https://github.com/aquasecurity/kube-bench/releases/tag/v${version}";
    description = "Checks whether Kubernetes is deployed according to security best practices as defined in the CIS Kubernetes Benchmark";
    mainProgram = "kube-bench";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jk ];
  };
}
