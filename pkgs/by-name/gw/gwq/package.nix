{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  testers,
  writableTmpDirAsHomeHook,
  gwq,
}:

buildGoModule rec {
  pname = "gwq";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "d-kuro";
    repo = "gwq";
    tag = "v${version}";
    hash = "sha256-T9G/sbI7P2I2yXNdX95SIr7Mzx87Z5oaqZmb6Y3Fooc=";
  };

  vendorHash = "sha256-c1vq9yETUYfY2BoXSEmRZj/Ceetu0NkIoVCM3wYy5iY=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/d-kuro/gwq/cmd.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    installShellCompletion --cmd gwq \
      --bash <($out/bin/gwq completion bash) \
      --fish <($out/bin/gwq completion fish) \
      --zsh <($out/bin/gwq completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = gwq;
  };

  meta = {
    description = "Git worktree manager with fuzzy finder";
    homepage = "https://github.com/d-kuro/gwq";
    changelog = "https://github.com/d-kuro/gwq/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ryoppippi ];
    mainProgram = "gwq";
  };
}
