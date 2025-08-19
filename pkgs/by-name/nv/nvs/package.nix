{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "nvs";
  version = "1.10.6";

  src = fetchFromGitHub {
    owner = "y3owk1n";
    repo = "nvs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hqIauWbAsWbD7P58BGnj6NlLtfuaR5YxOLgPOrpN++w=";
  };

  vendorHash = "sha256-l2FdnXA+vKVRekcIKt1R+MxppraTsmo0b/B7RNqnxjA=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Completions
  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];
  postInstall = ''
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
