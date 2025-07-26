{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-rmbu3WNwCmgojAWAthIQ9/XiSS04d9DoZwGRGAuRfDw=";
  };

  cargoHash = "sha256-7xpkxJh5KVJVw6wQZGr2daU1qg0e969EWflf4Z/01oY=";

  meta = with lib; {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
