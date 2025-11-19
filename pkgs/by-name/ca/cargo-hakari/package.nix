{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-hakari";
  version = "0.9.36";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    tag = "cargo-hakari-${finalAttrs.version}";
    hash = "sha256-qEYdJhLt4f3+RZz3/T6/vlQgrQYK6S5dNEmu8QH/wj0=";
  };

  cargoHash = "sha256-NrPfdVAi0QblJKFsHTL0BGQWUnqQEpIJwW3HBVHFZpE=";

  cargoBuildFlags = [
    "-p"
    "cargo-hakari"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

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
