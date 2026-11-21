{
  stdenv,
  lib,
  buildGo127Module,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  git,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "grut";
  version = "0.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jongio";
    repo = "grut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-se8O+XPEgVDiYAiTVIXvAcqA5nGrkfLQ/ngsr0ks9/Q=";
  };

  vendorHash = "sha256-XeqjaNSDm8uo33eA+KC9EyI+uICKRnzIbRM7xT/XxAM=";

  excludedPackages = [
    "cmd/contrib-notes"
    "internal/keybindings/cmd/genmd"
  ];

  ldflags = [
    "-s"
    "-X=github.com/jongio/grut/internal/config.AppVersion=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    git
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd grut \
      --bash <($out/bin/grut completion bash) \
      --fish <($out/bin/grut completion fish) \
      --zsh <($out/bin/grut completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal file explorer with full Git and GitHub integration, AI chat, and reactive panels that stay in sync as you navigate";
    homepage = "https://jongio.github.io/grut/";
    downloadPage = "https://github.com/jongio/grut";
    changelog = "https://github.com/jongio/grut/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "grut";
  };
})
