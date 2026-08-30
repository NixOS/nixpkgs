{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "dsearch";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "danksearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TnoKATODjWk4e1w3VhRYLWGMdXMJzDyvQF8mtD6WRGA=";
  };

  vendorHash = "sha256-Gq3tVwe39m5KGfkI3DEnQEQEGs/cLDCiwx6XFM61f6c=";

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
