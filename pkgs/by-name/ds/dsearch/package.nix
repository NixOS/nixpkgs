{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "dsearch";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "danksearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gU349UQcr6Cl23tPt1yHD7EcWM8Uw6HZmbeVXyLwGj0=";
  };

  vendorHash = "sha256-UGKcwrYQ+S1oC8lJ1EagU1Okfz/2ruj4bn/7APC2FWg=";

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
    maintainers = with lib.maintainers; [ luckshiba ];
    mainProgram = "dsearch";
    platforms = lib.platforms.unix;
  };
})
