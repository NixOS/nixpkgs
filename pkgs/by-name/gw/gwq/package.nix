{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  installShellFiles,
  makeWrapper,
  tmux,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "gwq";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "d-kuro";
    repo = "gwq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oSgDH5E3ETSlpovhU+MNmDTpY2BRGsR9Bf57ot04Rng=";
  };

  vendorHash = "sha256-jP4arRoTDcjRXZvLx7R/1pp5gRMpfZa7AAJDV+WLGhY=";

  subPackages = [ "cmd/gwq" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/d-kuro/gwq/internal/cmd.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    wrapProgram $out/bin/gwq \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          tmux
        ]
      }

    installShellCompletion --cmd gwq \
      --bash <($out/bin/gwq completion bash) \
      --fish <($out/bin/gwq completion fish) \
      --zsh <($out/bin/gwq completion zsh)
  '';

  meta = {
    description = "Git worktree manager with fuzzy finder interface";
    homepage = "https://github.com/d-kuro/gwq";
    changelog = "https://github.com/d-kuro/gwq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "gwq";
    maintainers = with lib.maintainers; [ ojii3 ];
    platforms = lib.platforms.unix;
  };
})
