{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule rec {
  pname = "dsearch";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "danksearch";
    tag = "v${version}";
    hash = "sha256-rtfymtzsxEuto1mOm8A5ubREJzXKCai6dw9Na1Fa21Q=";
  };

  vendorHash = "sha256-65NFlAtix5ehyaRok3/0Z6+j6U7ccc0Kdye0KFepLLM=";

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${version}"
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
    changelog = "https://github.com/AvengeMedia/danksearch/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luckshiba ];
    mainProgram = "dsearch";
    platforms = lib.platforms.unix;
  };
}
