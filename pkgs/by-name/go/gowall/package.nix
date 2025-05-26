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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Achno";
    repo = "gowall";
    rev = "v${version}";
    hash = "sha256-fgO4AoyHR51zD86h75b06BXV0ONlFfHdBvxfJvcD7J8=";
  };

  vendorHash = "sha256-V/VkbJZIzy4KlEPtlTTqdUIPG6lKD+XidNM0NWpATbk=";

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
