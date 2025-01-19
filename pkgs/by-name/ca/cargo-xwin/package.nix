{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-bzyEIBOa0yqjAYjWGw4Fbb8Cv3yCCfJ4vV0q600Rwyk=";
  };

  cargoHash = "sha256-uAQD1SUo8W5TtnZyprOFGztpOqvjPEDddA6CBPUN74g=";

  meta = {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ shivaraj-bh ];
  };
}
