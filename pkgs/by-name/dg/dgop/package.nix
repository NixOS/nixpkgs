{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "dgop";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Frp1/AE5jznFWS52FgN9daI6Kgi0yPx7bZVoFuEIylw=";
  };

  vendorHash = "sha256-NycCRxav1S/DW4fRlcLG5r5NsQQHbAE4zoOiF6Ut/bE=";

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/{cli,dgop}

    installShellCompletion --cmd dgop \
      --bash <($out/bin/dgop completion bash) \
      --fish <($out/bin/dgop completion fish) \
      --zsh <($out/bin/dgop completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "API & CLI for System & Process Monitoring";
    homepage = "https://github.com/AvengeMedia/dgop";
    changelog = "https://github.com/AvengeMedia/dgop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.danklinux ];
    mainProgram = "dgop";
    platforms = lib.platforms.unix;
  };
})
