{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "keepassxc-go";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "MarkusFreitag";
    repo = "keepassxc-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0VQw12o4XTzKOz+45sHIKSsIjBxDcdxtgYUItFznsO4=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-p7Lj2x0+F3kmAMi+2gtBYkg1w8jmgWm3kgYAoIagERs=";

  checkFlags = [
    # Test tries to monkey-patch the stdlib, fails with permission denied error.
    "-skip=TestKeystore"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    local INSTALL="$out/bin/keepassxc-go"
    installShellCompletion --cmd keepassxc-go \
      --bash <($out/bin/keepassxc-go completion bash) \
      --fish <($out/bin/keepassxc-go completion fish) \
      --zsh <($out/bin/keepassxc-go completion zsh)
  '';

  meta = {
    description = "Library and basic CLI tool to interact with KeepassXC via unix socket";
    homepage = "https://github.com/MarkusFreitag/keepassxc-go";
    changelog = "https://github.com/MarkusFreitag/keepassxc-go/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "keepassxc-go";
  };
})
