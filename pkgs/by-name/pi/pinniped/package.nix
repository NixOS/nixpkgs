{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "pinniped";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "pinniped";
    rev = "v${version}";
    sha256 = "sha256-1r5EjF4Npt1iwlILTCHKlViO5MPcv8undKYJWN8cmVA=";
  };

  subPackages = "cmd/pinniped";

  vendorHash = "sha256-aDP5yf0uGYSzvYqqRUS4P2ozLCRcS0eDJseicXv/99o=";

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
