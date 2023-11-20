{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec{
  pname = "pinniped";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "pinniped";
    rev = "v${version}";
    sha256 = "sha256-Nhm2dLEFI+fAJ2lLE9z+3Qug3bbsoiRjex89Pa9oAVQ=";
  };

  subPackages = "cmd/pinniped";

  vendorHash = "sha256-4y513BkV3EYgqlim2eXw02m36wtUVQeegmQiMZ3HyWg=";

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
