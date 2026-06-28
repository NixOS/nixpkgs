{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-xwin";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pWaJKk4XgBeY4llRTHvuMg0mAfEV4GFpeWGaM8eYsN4=";
  };

  cargoHash = "sha256-iO0uAYdi8Vy9gi7lHsGRmhDsVNQCqo4E/nbTfI32jDs=";

  meta = {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ shivaraj-bh ];
  };
})
