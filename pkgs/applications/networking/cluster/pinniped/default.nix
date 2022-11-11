{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec{
  pname = "pinniped";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "pinniped";
    rev = "v${version}";
    sha256 = "sha256-JKZij9f6zlBzbYolxz03R5j95zKELVmEhX+QRTxF/cc=";
  };

  subPackages = "cmd/pinniped";

  vendorSha256 = "sha256-szv/B7LG/In0j6MT6KCnuUfaCnK7RsJOLeuOtJ/ig9w=";

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
