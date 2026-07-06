{
  dbus,
  fetchFromGitHub,
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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "clearloop";
    repo = "leetcode-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h3mCZzif+Uzv3bsEb9I24txrx1BHkc5I86gWcwDHsOc=";
  };

  cargoHash = "sha256-8bHpNckEsJ4VWlmEaDTeMW+Txi9SQh30lK5CKKperC8=";

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
