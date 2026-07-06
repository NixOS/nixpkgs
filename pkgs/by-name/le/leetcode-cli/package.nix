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
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "clearloop";
    repo = "leetcode-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qg4Sd3tcyOZsPl++/Y6qU2tTCzJ4nL062kJn6gSMygI=";
  };

  cargoHash = "sha256-bbwyuFY3i/pcWBJjaKIZf2zHEkp4raZp7i5cWZtS9w8=";

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
    maintainers = with lib.maintainers; [
      congee
      ethancedwards8
    ];
    mainProgram = "leetcode";
  };
})
