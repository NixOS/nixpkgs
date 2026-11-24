{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  perl,
  libgit2,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "geode-cli";
  version = "4.0.2";

  geode = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/geode${stdenv.hostPlatform.extensions.executable}";

  src = fetchFromGitHub {
    owner = "geode-sdk";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ygfBAIioXoA5IH4vQb5wFNSBA7ODnJiI9/reIQ5tR3M=";
  };

  cargoHash = "sha256-pCyChlSfmI7rXrgVTQ4t0hdmTuxgY4LAQTAv7/56Qlk=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    perl
  ];

  buildInputs = [
    libgit2
    openssl
    zstd
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
    changelog = "https://github.com/geode-sdk/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ not-a-cowfr ];
    mainProgram = "geode";
  };
})
