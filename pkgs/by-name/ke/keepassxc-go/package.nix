{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "keepassxc-go";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "MarkusFreitag";
    repo = "keepassxc-go";
    rev = "v${version}";
    hash = "sha256-Z4SbPxhs+umsUlby7idxofCjP+uLPvp/2oUCpnAS2/A=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-+cgf2FxpbLu+Yuhk6T0ZBnDH7We2DVu65xFaruk9I0E=";

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
    changelog = "https://github.com/MarkusFreitag/keepassxc-go/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "keepassxc-go";
  };
}
