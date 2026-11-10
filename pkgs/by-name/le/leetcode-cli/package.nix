{
  dbus,
  fetchCrate,
  installShellFiles,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  sqlite,
  stdenv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leetcode-cli";
  version = "0.5.5";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-aBmgZh25ZGffMTlhvNbjBlKofEJ1+WyhkgOQ7m8Nv8Q=";
  };

  cargoHash = "sha256-O4UStE3Iej2HDusXbxVCBfIVtCQ2l0ifMWb6itbnbLU=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
    sqlite
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd leetcode \
      --bash <($out/bin/leetcode completions bash) \
      --fish <($out/bin/leetcode completions fish) \
      --zsh <($out/bin/leetcode completions zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Leetcode CLI utility";
    homepage = "https://github.com/clearloop/leetcode-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ congee ];
    mainProgram = "leetcode";
  };
})
