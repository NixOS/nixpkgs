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

  useFetchCargoVendor = true;
  cargoHash = "sha256-nOcwHy+aji1LgR/VBZDRFDgM+b2ScpVE+H3W5HKEM5o=";

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
