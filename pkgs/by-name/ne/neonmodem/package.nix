{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "neonmodem";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "neonmodem";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gwhQG8H1OnGQmawPQ3m6VKVooBh8rZaNr6FDl6fgZXc=";
  };

  vendorHash = "sha256-zqQtuyFrsDB1xRdl4cbaTsCawMrBvcu78zXgU2jUwHI=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Will otherwise panic if it can't open $HOME/{Library/Caches,.cache}/neonmodem.log
    # Upstream issue: https://github.com/mrusme/neonmodem/issues/53
    mkdir -p "$HOME/${if stdenv.buildPlatform.isDarwin then "Library/Caches" else ".cache"}"

    installShellCompletion --cmd neonmodem \
      --bash <($out/bin/neonmodem completion bash) \
      --fish <($out/bin/neonmodem completion fish) \
      --zsh <($out/bin/neonmodem completion zsh)
  '';

  meta = {
    description = "BBS-style TUI client for Discourse, Lemmy, Lobsters, and Hacker News";
    homepage = "https://neonmodem.com";
    downloadPage = "https://github.com/mrusme/neonmodem/releases";
    changelog = "https://github.com/mrusme/neonmodem/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ acuteaangle ];
    mainProgram = "neonmodem";
  };
})
