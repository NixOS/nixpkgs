{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
  udev,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "cargo-v5";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "vexide";
    repo = "cargo-v5";
    rev = "9d5f6e014c80838ff2b0cca401bcbd518c1e9274";
    hash = "sha256-bXzJvlhG/IJOu+D1iluJD3wDoiJXWzXYJ+ZUG6xMCeA=";
  };

  cargoHash = "sha256-OQ3XY8RzmjGZWFyTY3HY9AYb8qDHHeEAuWa+3WNOtRM=";

  buildFeatures = [ "full" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    udev
    openssl
  ];

  meta = {
    description = "Cargo tool for working with VEX V5 Rust projects";
    mainProgram = "cargo-v5";
    homepage = "https://github.com/vexide/cargo-v5";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ max-niederman ];
  };
}
