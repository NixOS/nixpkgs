{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "pinniped";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "pinniped";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-KYhMJjUu+6suT9o4RbGRyBl5ItiYt/5JQPg4fUzqs0M=";
  };

  subPackages = "cmd/pinniped";

  vendorHash = "sha256-PAq+Oc8+Iib3/hBGrC0xQl+kBtWtsU7XS0alJePkO7k=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pinniped \
      --bash <($out/bin/pinniped completion bash) \
      --fish <($out/bin/pinniped completion fish) \
      --zsh <($out/bin/pinniped completion zsh)
  '';

  meta = {
    description = "Tool to securely log in to your Kubernetes clusters";
    mainProgram = "pinniped";
    homepage = "https://pinniped.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bpaulin ];
  };
})
