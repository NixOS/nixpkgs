{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "abbreviate";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "dnnrly";
    repo = "abbreviate";
    tag = "v${version}";
    hash = "sha256-foGg+o+BbPsfpph+XHIfyPaknQD1N1rcZW58kgZ5HYM=";
  };

  vendorHash = "sha256-9z3M3FEjllNpae+5EcLVkF1rAtOQzUQGebJeU7QsmTA=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd abbreviate \
      --bash <($out/bin/abbreviate completion bash) \
      --fish <($out/bin/abbreviate completion fish) \
      --zsh <($out/bin/abbreviate completion zsh)
  '';

  meta = {
    description = "Shorten your strings using common abbreviations";
    mainProgram = "abbreviate";
    homepage = "https://github.com/dnnrly/abbreviate";
    changelog = "https://github.com/dnnrly/abbreviate/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
