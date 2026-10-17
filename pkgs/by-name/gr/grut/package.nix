{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  git,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "grut";
  version = "0.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jongio";
    repo = "grut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2tMJR6Vp5Ps9OY6ORdalyCwZhcmuU/EV0nmF7juZ3Ls=";
  };

  vendorHash = "sha256-kQRxT3iGsRXQ6L/38cQCtE18CN2sQZKZIvuOmtv6Ye8=";

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

  __darwinAllowLocalNetworking = true;

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
