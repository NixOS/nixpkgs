{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec{
  pname = "pinniped";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "pinniped";
    rev = "v${version}";
    sha256 = "sha256-z+JwtrP3WGMK11RRYrDig5SrX6YCj7U3AwuLg/J8dgs=";
  };

  subPackages = "cmd/pinniped";

  vendorHash = "sha256-QywpqgQj76x0zmn4eC74fy7UECK4K81WO+nxOYKZqq0=";

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
