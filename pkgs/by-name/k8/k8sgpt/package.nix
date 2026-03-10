{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "k8sgpt";
  version = "0.4.30";

  nativeBuildInputs = [
    installShellFiles
  ];

  src = fetchFromGitHub {
    owner = "k8sgpt-ai";
    repo = "k8sgpt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8hzJEJ+aZ+nVleStMngRortRLEoW+6FhcYBgin3Z/3Y=";
  };

  vendorHash = "sha256-zljqZWM1jSAC+ZhW1NNp182Ui/40u0VTtfolnPXQKqE=";

  # https://nixos.org/manual/nixpkgs/stable/#var-go-CGO_ENABLED
  env.CGO_ENABLED = 0;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  # https://nixos.org/manual/nixpkgs/stable/#ssec-skip-go-tests
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd k8sgpt \
      --bash <($out/bin/k8sgpt completion bash) \
      --zsh <($out/bin/k8sgpt completion zsh) \
      --fish <($out/bin/k8sgpt completion fish)
  '';

  meta = {
    description = "Giving Kubernetes Superpowers to everyone";
    mainProgram = "k8sgpt";
    homepage = "https://k8sgpt.ai";
    changelog = "https://github.com/k8sgpt-ai/k8sgpt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      developer-guy
      kranurag7
      mrgiles
    ];
  };
})
