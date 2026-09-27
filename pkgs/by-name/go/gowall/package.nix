{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "gowall";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "Achno";
    repo = "gowall";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mogjHIsm+N3/wtrfayiKuYe6REPVrt8xLZDpgdKkX34=";
  };

  vendorHash = "sha256-nRmW7jGcURbrXVwg5kxmloet2aV2s8JjhEeO1KybtME=";

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
    changelog = "https://github.com/Achno/gowall/releases/tag/v${finalAttrs.version}";
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
})
