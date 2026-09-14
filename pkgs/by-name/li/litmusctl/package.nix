{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  kubectl,
  lib,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "litmusctl";
  version = "1.27.0";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    kubectl
  ];

  src = fetchFromGitHub {
    owner = "litmuschaos";
    repo = "litmusctl";
    rev = "${finalAttrs.version}";
    hash = "sha256-jVbWgwW7qkGLY2T0SbK0Y/GItLj1BfLn1cloPyItpvI=";
  };

  vendorHash = "sha256-Lkvc8dBr/nvKczx83/KXKLe5FskGpI/17GIrl2y/E1I=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd litmusctl \
      --bash <($out/bin/litmusctl completion bash) \
      --fish <($out/bin/litmusctl completion fish) \
      --zsh <($out/bin/litmusctl completion zsh)
  '';

  meta = {
    description = "Command-Line tool to manage Litmuschaos's agent plane";
    homepage = "https://github.com/litmuschaos/litmusctl";
    license = lib.licenses.asl20;
    mainProgram = "litmusctl";
    maintainers = with lib.maintainers; [
      vinetos
      sailord
    ];
  };
})
