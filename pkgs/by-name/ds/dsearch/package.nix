{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "dsearch";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "danksearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Ka2sH6l7lnkXV832o0tMK3i9A4zSYFtaYZL6LNgWvc=";
  };

  vendorHash = "sha256-nvAgDX8dS3ZwAGTdPvNK1/XzlY28/QjRSW8cmqhp9io=";

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    install -Dm744 ./assets/dsearch.service $out/lib/systemd/user/dsearch.service
    substituteInPlace $out/lib/systemd/user/dsearch.service \
      --replace-fail /usr/local/bin/dsearch $out/bin/dsearch

    installShellCompletion --cmd dsearch \
      --bash <($out/bin/dsearch completion bash) \
      --fish <($out/bin/dsearch completion fish) \
      --zsh <($out/bin/dsearch completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast, configurable filesystem search with fuzzy matching";
    homepage = "https://github.com/AvengeMedia/danksearch";
    changelog = "https://github.com/AvengeMedia/danksearch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.danklinux ];
    mainProgram = "dsearch";
    platforms = lib.platforms.unix;
  };
})
