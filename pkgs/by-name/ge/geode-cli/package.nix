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

let
  pname = "geode-cli";
  version = "3.7.4";

  geode = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/geode${stdenv.hostPlatform.extensions.executable}";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "geode-sdk";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-OJPAwFi4ffSYyHreKubICxiTlTCsfKNoYbJj2r+/0n8=";
  };

  cargoHash = "sha256-X8fiKuhEszGbeVV9n6rrNEbGcTzmp3DCprI6cJPN+VY=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
  ];

  # nushell completions are awaiting a new release with the merged nushell completion changes
  postFixup = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
    installShellCompletion --cmd geode \
      --fish <(${geode} completions fish) \
      --bash <(${geode} completions bash) \
      --zsh <(${geode} completions zsh)

    installManPage --name geode.1 <(${geode} generate-manpage)
  '';

  meta = {
    description = "Command-line utilities for working with geode";
    homepage = "https://github.com/geode-sdk/cli";
    changelog = "https://github.com/geode-sdk/cli/releases/tag/v${version}";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ not-a-cowfr ];
    mainProgram = "geode";
  };
}
