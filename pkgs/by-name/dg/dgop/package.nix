{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "dgop";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CxTvTx7WYKj9usa1uZDUmCqS9+W0QoIeTGDlkhHLVho=";
  };

  vendorHash = "sha256-4GslUKwUCO8oOqylsclJmAZL/ds0plenzcTAwAXKtrc=";

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
