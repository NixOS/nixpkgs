{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec{
  pname = "pinniped";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "pinniped";
    rev = "v${version}";
    sha256 = "sha256-v1VuCM6sMNVj6nAVuqphDUVGBc3k0oYJWt9TJb/3fP4=";
  };

  subPackages = "cmd/pinniped";

  vendorHash = "sha256-k3fFr83LPY10ASLERzUO/8ojZgx3LLGFEIjMxaGehTs=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd pinniped \
      --bash <($out/bin/pinniped completion bash) \
      --fish <($out/bin/pinniped completion fish) \
      --zsh <($out/bin/pinniped completion zsh)
  '';

  meta = with lib; {
    description = "Tool to securely log in to your Kubernetes clusters";
    homepage = "https://pinniped.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bpaulin ];
  };
}
