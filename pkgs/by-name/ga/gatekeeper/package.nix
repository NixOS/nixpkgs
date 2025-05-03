{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "gatekeeper";
  version = "3.19.1";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "gatekeeper";
    tag = "v${version}";
    hash = "sha256-zU/OAiWc6H4YC5bnDFrqpfCT1HhDGCm+dkjriP2Wp3w=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-X github.com/open-policy-agent/gatekeeper/v3/pkg/version.Version=${version}"
  ];

  subPackages = [ "cmd/gator" ];

  postInstall = ''
    installShellCompletion --cmd gator \
      --bash <($out/bin/gator completion bash) \
      --fish <($out/bin/gator completion fish) \
      --zsh <($out/bin/gator completion zsh)
  '';

  meta = with lib; {
    description = "Policy Controller for Kubernetes";
    mainProgram = "gator";
    homepage = "https://github.com/open-policy-agent/gatekeeper";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
