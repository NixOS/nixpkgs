{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-hakari";
  version = "0.9.37";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    tag = "cargo-hakari-${finalAttrs.version}";
    hash = "sha256-Rf/1IhcvSp9Q8dLo/kuG0O9uIUH15Aw567ggaABANJw=";
  };

  cargoHash = "sha256-vL+1oJO9qTg/SX0mvt3hvKo1t3FhQJmUSLoK6LZuqZc=";

  cargoBuildFlags = [
    "-p"
    "cargo-hakari"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage workspace-hack packages to speed up builds in large workspaces";
    longDescription = ''
      cargo hakari is a command-line application to manage workspace-hack crates.
      Use it to speed up local cargo build and cargo check commands by 15-95%,
      and cumulatively by 20-25% or more.
    '';
    homepage = "https://crates.io/crates/cargo-hakari";
    changelog = "https://github.com/guppy-rs/guppy/blob/cargo-hakari-${finalAttrs.version}/tools/cargo-hakari/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      macalinao
      nartsiss
    ];
    mainProgram = "cargo-hakari";
  };
})
