{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "pinniped";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "pinniped";
    rev = "v${version}";
    sha256 = "sha256-VFBiy7EKJ0J407PAWDlBNXxLWpZ4w3ai4yk32kn18rI=";
  };

  subPackages = "cmd/pinniped";

  vendorHash = "sha256-OGZ9/pXudz9YmxeEkMP710+RwHOCig0yDqo+X/o9eJw=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd pinniped \
      --bash <($out/bin/pinniped completion bash) \
      --fish <($out/bin/pinniped completion fish) \
      --zsh <($out/bin/pinniped completion zsh)
  '';

  meta = with lib; {
    description = "Tool to securely log in to your Kubernetes clusters";
    mainProgram = "pinniped";
    homepage = "https://pinniped.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bpaulin ];
  };
}
