{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
  udev,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-v5";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "vexide";
    repo = "cargo-v5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uIJcl1WfL96tvJ5QebbqnsP4nQqW7aCp4XYXgfu7CuY=";
  };

  cargoHash = "sha256-D7zRkzJwh0jBTUFJhggG7Bc5ixMZ4YLtaqZihEQN6hM=";

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
})
