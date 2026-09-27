{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "geode-cli";
  version = "3.8.0";

  geode = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/geode${stdenv.hostPlatform.extensions.executable}";

  src = fetchFromGitHub {
    owner = "geode-sdk";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tdfgf7qI7NzUhP8wgxx7Nbqr93VG34O7cWbOwGOkUQs=";
  };

  cargoHash = "sha256-UwiRYQe848Kxcy8Y9Ef2nebNiKsGsWEjLbk2onphov0=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
  ];

  postFixup = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
    installShellCompletion --cmd geode \
      --fish <(${finalAttrs.geode} completions fish) \
      --bash <(${finalAttrs.geode} completions bash) \
      --zsh <(${finalAttrs.geode} completions zsh) \
      --nushell <(${finalAttrs.geode} completions nushell)

    installManPage --name geode.1 <(${finalAttrs.geode} generate-manpage)
  '';

  __structuredAttrs = true;

  meta = {
    description = "Command-line utilities for working with geode";
    homepage = "https://github.com/geode-sdk/cli";
    changelog = "https://github.com/geode-sdk/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ not-a-cowfr ];
    mainProgram = "geode";
  };
})
