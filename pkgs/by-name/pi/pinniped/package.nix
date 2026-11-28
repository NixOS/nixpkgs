{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "pinniped";
  version = "0.48.0";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = "pinniped";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-G+/whK/5vrFoYiOY1jvcpmxzM7LNDYSZpnurWL/RKuE=";
  };

  subPackages = "cmd/pinniped";

  vendorHash = "sha256-xfObKFAacsaOgsOS3IKtdmfB1VUbOumbrlyWWKyxPKY=";

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
