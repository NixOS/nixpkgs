{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "keepassxc-go";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "MarkusFreitag";
    repo = "keepassxc-go";
    rev = "v${version}";
    hash = "sha256-seCeHNEj5GxAI7BVMPzh+YuoxivmTwvhVCqY5LKHpQk=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-jscyNyVr+RDN1EaxIOc3aYCAVT+1eO/c+dxEsIorDIs=";

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

  meta = with lib; {
    description = "Library and basic CLI tool to interact with KeepassXC via unix socket";
    homepage = "https://github.com/MarkusFreitag/keepassxc-go";
    changelog = "https://github.com/MarkusFreitag/keepassxc-go/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ xgwq ];
    mainProgram = "keepassxc-go";
  };
}
