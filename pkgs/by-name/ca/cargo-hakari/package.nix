{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
  version = "0.9.35";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    tag = "cargo-hakari-${version}";
    hash = "sha256-+IjtK4kSm2vThgIxDsBLpoh0j9cDhhEqI6Hr2BmC7hc=";
  };

  cargoHash = "sha256-yAk0hMB3OEaaIuNqiJtl1K5P19pOGtiyt4cvU+Nb814=";

  cargoBuildFlags = [
    "-p"
    "cargo-hakari"
  ];
  cargoTestFlags = [
    "-p"
    "cargo-hakari"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Manage workspace-hack packages to speed up builds in large workspaces";
    mainProgram = "cargo-hakari";
    longDescription = ''
      cargo hakari is a command-line application to manage workspace-hack crates.
      Use it to speed up local cargo build and cargo check commands by 15-95%,
      and cumulatively by 20-25% or more.
    '';
    homepage = "https://crates.io/crates/cargo-hakari";
    changelog = "https://github.com/guppy-rs/guppy/blob/cargo-hakari-${version}/tools/cargo-hakari/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      figsoda
      macalinao
      nartsiss
    ];
  };
}
