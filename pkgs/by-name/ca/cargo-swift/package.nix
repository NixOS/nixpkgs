{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-swift";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "antoniusnaumann";
    repo = "cargo-swift";
    rev = "v${version}";
    hash = "sha256-koHQaYfMDc8GxQ+K7C1YluMY5u4cUGV8/Ehjt/KWl/g=";
  };

  cargoHash = "sha256-8aFISZ2nzCmxxKkX77jEOE/MWcKwyTw8IGTEbJ0mKWg=";

  meta = {
    description = "Cargo plugin to easily build Swift packages from Rust code";
    mainProgram = "cargo-swift";
    homepage = "https://github.com/antoniusnaumann/cargo-swift";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ elliot ];
  };
}
