{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  makeBinaryWrapper,
  installShellFiles,
  delta,
}:

buildGoModule (finalAttrs: {
  pname = "diffnav";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "diffnav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6VtAQzZNLQrf8QYVXxLUgb3F6xguFDbwaE9kahPhbSE=";
  };

  vendorHash = "sha256-gmmckzR0D1oFuTG5TAb6gLMoNbcZl9EsjbFjhPfJqnQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ];
  postInstall = ''
    wrapProgram $out/bin/diffnav \
      --prefix PATH : ${lib.makeBinPath [ delta ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd diffnav \
     --bash <($out/bin/diffnav completion bash) \
     --fish <($out/bin/diffnav completion fish) \
     --zsh <($out/bin/diffnav completion zsh)
  '';

  meta = {
    changelog = "https://github.com/dlvhdr/diffnav/releases/tag/${finalAttrs.src.rev}";
    description = "Git diff pager based on delta but with a file tree, à la GitHub";
    homepage = "https://github.com/dlvhdr/diffnav";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      amesgen
      matthiasbeyer
    ];
    mainProgram = "diffnav";
  };
})
