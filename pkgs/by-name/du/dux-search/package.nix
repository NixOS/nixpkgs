{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "dux-search";
  version = "2.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "duxlabs-dev";
    repo = "dux-search";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GOnNob/tex//NBchfVXAjzk9Gw4K+GxyVmZBZqx0nLA=";
  };

  vendorHash = "sha256-MkRBJPsHHgH2z/hTt8Z6SM/+KNQ8PuipBALW8qbJldE=";

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
    homepage = "https://github.com/duxlabs-dev/dux-search";
    changelog = "https://github.com/duxlabs-dev/dux-search/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.duxlabs ];
    mainProgram = "dsearch";
    platforms = lib.platforms.unix;
  };
})
