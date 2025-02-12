{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    rev = version;
    hash = "sha256-PC36O5+eB+yVLpz+EywBDGcMAtHl79FYwUo/l/JL8hM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lyw7UJrGBL1+ATma3TWBpgjstSHGYMWAyTiq1nJNhgE=";

  doCheck = false;

  meta = with lib; {
    description = "Command line helpers for fuzzing";
    mainProgram = "cargo-fuzz";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      ekleog
      matthiasbeyer
    ];
  };
}
