{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "nvs";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "y3owk1n";
    repo = "nvs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qbOO/MKz5ak5XXvSZWDmNFTIh/cHXRtvDj2xZ5tTfu0=";
  };

  vendorHash = "sha256-TgDeVmiMHS+d5+6mOCnoTJctcKsW44JYKjjflaVQqJc=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Completions
  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd nvs \
      --bash <($out/bin/nvs completion bash) \
      --fish <($out/bin/nvs completion fish) \
      --zsh <($out/bin/nvs completion zsh)
  '';

  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    mainProgram = "nvs";
    description = "Lightweight Neovim Version & Config Manager CLI tool to install, switch, list, uninstall, and reset Neovim versions";
    homepage = "https://github.com/y3owk1n/nvs";
    changelog = "https://github.com/y3owk1n/nvs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cupcakearmy
    ];
  };
})
