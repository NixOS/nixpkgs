{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "gowall";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "Achno";
    repo = "gowall";
    rev = "v${version}";
    hash = "sha256-HZEVH3T4dmBE4OMPjtHj3qdeT4i27+YhZWJgYqbg5ss=";
  };

  vendorHash = "sha256-zQoXrQnejng1jBKRMaQzQaZYKWxJPXjgdplnuVhazuM=";

  nativeBuildInputs = [
    installShellFiles
    # using writableTmpDirAsHomeHook to prevent issues when creating config dir for shell completions
    writableTmpDirAsHomeHook
  ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gowall \
      --bash <($out/bin/gowall completion bash) \
      --fish <($out/bin/gowall completion fish) \
      --zsh <($out/bin/gowall completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Achno/gowall/releases/tag/v${version}";
    description = "Tool to convert a Wallpaper's color scheme / palette";
    homepage = "https://github.com/Achno/gowall";
    license = lib.licenses.mit;
    mainProgram = "gowall";
    maintainers = with lib.maintainers; [
      crem
      emilytrau
      FKouhai
    ];
  };
}
