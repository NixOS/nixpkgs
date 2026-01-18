{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-M7OO2yO5BvNTqJLI50g25M5aupdOxmlZ3eealmP51Kc=";
  };

  cargoHash = "sha256-DwQGmdSzEjzqfsvqczAMJfi9gJjK2b9FAGmMi7rGKuw=";

  meta = {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ shivaraj-bh ];
  };
}
