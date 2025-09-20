{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "pinniped";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "pinniped";
    rev = "v${version}";
    sha256 = "sha256-PCSRT3oYqfIsB5vWDIBV1tzRovDfrZOjLrINzos1RL0=";
  };

  subPackages = "cmd/pinniped";

  vendorHash = "sha256-UYDmTwbT5odLMthGRqWuSr4G4oAU8zuWWRrMclIaY8g=";

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

  meta = with lib; {
    description = "Tool to securely log in to your Kubernetes clusters";
    mainProgram = "pinniped";
    homepage = "https://pinniped.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bpaulin ];
  };
}
