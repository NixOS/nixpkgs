{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
  version = "0.9.33";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "cargo-hakari-${version}";
    sha256 = "sha256-oJZiGXsOl00Bim/olYYSqt/p3j6dTw25IURcwdXYrAo=";
  };

  cargoHash = "sha256-V9QmaZYBXj26HJrP8gABwhhUPwBxnyLoO4O45lnPyew=";

  cargoBuildFlags = [
    "-p"
    "cargo-hakari"
  ];
  cargoTestFlags = [
    "-p"
    "cargo-hakari"
  ];

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
