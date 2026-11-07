{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bp";
  version = "0.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "battery-pack-rs";
    repo = "battery-pack";
    tag = "cargo-bp-v${finalAttrs.version}";
    hash = "sha256-9hfr0wF5m3rME0gHlZ50OHZzUPseS1rJsbGAwIRNcE8=";
  };

  cargoHash = "sha256-SxUKCYMqQLY3qWKoRLKfOV4qzfjUb9nD2y03Zmnn3nA=";

  nativeBuildInputs = [ installShellFiles ];
  buildAndTestSubdir = "src/cargo-bp";

  # Integration tests spawn cargo commands that fail in the Nix sandbox
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cargo-bp \
      --bash <($out/bin/cargo-bp bp completions bash) \
      --zsh <($out/bin/cargo-bp bp completions zsh) \
      --fish <($out/bin/cargo-bp bp completions fish)
  '';

  meta = {
    description = "CLI for creating and managing battery packs (cargo bp)";
    longDescription = ''
      A battery pack bundles everything you need to get started in
      an area: curated crates, documentation, examples, and templates.

      Think of it like an addition to the standard library targeting
      a particular use case, like building a CLI tool or web server.
    '';
    homepage = "https://github.com/battery-pack-rs/battery-pack";
    changelog = "https://github.com/battery-pack-rs/battery-pack/releases/tag/cargo-bp-v${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ yusufraji ];
    mainProgram = "cargo-bp";
  };
})
